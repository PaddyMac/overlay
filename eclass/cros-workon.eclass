# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

#
# Original Author: The Chromium OS Authors <chromium-os-dev@chromium.org>
# Purpose: Library for handling building of ChromiumOS packages
#

# @ECLASS-VARIABLE: CROS_WORKON_SRCROOT
# @DESCRIPTION:
# Directory where chrome third party and platform sources are located (formerly CHROMEOS_ROOT)
: ${CROS_WORKON_SRCROOT:=}

# @ECLASS-VARIABLE: CROS_WORKON_SUBDIR
# @DESCRIPTION:
# Sub-directory which is added to create full source checkout path
: ${CROS_WORKON_SUBDIR:=}

# @ECLASS-VARIABLE: CROS_WORKON_REPO
# @DESCRIPTION:
# Git URL which is prefixed to CROS_WORKON_PROJECT
: ${CROS_WORKON_REPO:=http://git.chromium.org/git}

# @ECLASS-VARIABLE: CROS_WORKON_PROJECT
# @DESCRIPTION:
# Git project name which is suffixed to CROS_WORKON_REPO
: ${CROS_WORKON_PROJECT:=${PN}}}

# @ECLASS-VARIABLE: CROS_WORKON_LOCALNAME
# @DESCRIPTION:
# Temporary local name in third_party
: ${CROS_WORKON_LOCALNAME:=${PN}}}

# @ECLASS-VARIABLE: CROS_WORKON_COMMIT
# @DESCRIPTION:
# Git commit to checkout to
: ${CROS_WORKON_COMMIT:=master}

# @ECLASS-VARIABLE: CROS_WORKON_LOCALGIT
# @DESCRIPTION:
# Use git to perform local copy
: ${CROS_WORKON_LOCALGIT:=}

# @ECLASS-VARIABLE: CROS_WORKON_INPLACE
# @DESCRIPTION:
# Build the sources in place. Don't copy them to a temp dir.
: ${CROS_WORKON_INPLACE:=}

inherit git flag-o-matic

# Calculate path where code should be checked out.
get_path() {
	local path

	if [[ -n "${CROS_WORKON_SRCROOT}" ]]; then
		path="${CROS_WORKON_SRCROOT}"
	elif [[ -n "${CHROMEOS_ROOT}" ]]; then
		path="${CHROMEOS_ROOT}"
	else
		# HACK: figure out the missing legacy path for now
		# this only happens in amd64 chroot with sudo emerge
		path="/home/${SUDO_USER}/trunk"
	fi

	if [[ "${CATEGORY}" == "chromeos-base" ]] ; then
		path+=/src/platform
	else
		path+=/src/third_party
	fi

	if [[ -n "${CROS_WORKON_LOCALNAME}" ]]; then
		path+="/${CROS_WORKON_LOCALNAME}"
	fi
	if [[ -n "${CROS_WORKON_SUBDIR}" ]]; then
		path+="/${CROS_WORKON_SUBDIR}"
	fi
	echo ${path}
}

local_copy_git() {
	CLONE_OPTS="--no-hardlinks --shared"
	PATCHFILE="${WORKDIR}/${P}"/local_changes.patch

	einfo "Using experimental git copy! Beware!"

	# this produces a local clean copy of ${1} at the same branch
	git clone ${CLONE_OPTS} "${1}" "${WORKDIR}/${P}" || \
		die "Cannot clone local copy"

	# collect local changes
	git --binary --git-dir="${1}" --work-dir="${1}/.git" diff HEAD > "${PATCHFILE}" || \
		die "Cannot create local changes patch"

	# apply local changes
	# note: wc prints file name after byte count
	if [ "$(wc -c ${PATCHFILE})" != "0 ${PATCHFILE}" ]; then
		git --git-dir="${WORKDIR}/${P}" --work-dir="${WORKDIR}/${P}/.git" apply ${PATCHFILE} || \
			die "Cannot apply local changes"
	fi
}

local_copy_cp() {
	einfo "Copying sources"

	mkdir -p "${S}"
	cp -a "${1}"/* "${S}" || die "cp -a ${1}/* ${S}"
}

symlink_in_place() {
	einfo "Using experimental inplace build! Beware!"

	SBOX_TMP=":${SANDBOX_WRITE}:"

	if [ "${SBOX_TMP/:$CROS_WORKON_SRCROOT://}" == "${SBOX_TMP}" ]; then
		ewarn "For inplace build you need to modify the sandbox"
		ewarn "Set SANDBOX_WRITE=${CROS_WORKON_SRCROOT} in your env."
	fi

	ln -sf ${1} ${S}
}

local_copy() {
	local srcpath=$1

	# If we want to use git, and the source actually is a git repo
	if [ "${CROS_WORKON_INPLACE}" == "1" ]; then
		symlink_in_place ${srcpath}
	elif [ -n "${CROS_WORKON_LOCALGIT}" ] && [ -d ${srcpath}/.git ]; then
		local_copy_git ${srcpath}
	else
		local_copy_cp ${srcpath}
	fi
}

cros-workon_src_unpack() {
	local fetch_method # local|git

	case ${PV} in
	(9999)
		fetch_method=local
		;;
	(*)
		if [[ -z "${CROS_WORKON_SRCROOT}" ]]; then # old workflow
			fetch_method=local
			# HACK: this needs to go away with the transition to new workflow
			# and also the same thing below
			DONTFETCH=1
		else # new workflow
			fetch_method=git
		fi
		;;
	esac

	# Hack
	# TODO(msb): remove once we've resolved the include path issue
	# http://groups.google.com/a/chromium.org/group/chromium-os-dev/browse_thread/thread/5e85f28f551eeda/3ae57db97ae327ae
	ln -s "${S}" "${WORKDIR}/${CROS_WORKON_LOCALNAME}" &> /dev/null

	local repo=${CROS_WORKON_REPO}
	local project=${CROS_WORKON_PROJECT}
	local path=$(get_path)

	if [[ "${fetch_method}" == "git" ]] ; then
		if [[ -d ${path}/.git ]] ; then
			# Looks like we already have a local copy of the git repository.
			# Let's use that repository and checkout ${CROS_WORKON_COMMIT}.
			#  -s: For speed, share objects between ${path} and ${S}.
			#  -n: Don't checkout any files from the repository yet. We'll
			#      checkout the source separately.
			#
			# We don't use git clone to checkout the source because the -b
			# option for clone defaults to HEAD if it can't find the revision
			# you requested. On the other hand, git checkout fails if it can't
			# find the revision you requested, so we use that instead.
			local fetched=false
			if [[ "${CROS_WORKON_COMMIT}" = "master" ]]; then
				# Since we don't have a CROS_WORKON_COMMIT revision specified,
				# we don't know what revision the ebuild wants. Let's take the
				# version of the code that the user has checked out.
				#
				# This almost replicates the pre-cros-workon behavior, where
				# the code you had in your source tree was used to build
				# things. One difference here, however, is that only committed
				# changes are included.
				#
				# TODO(davidjames): We should fix the preflight buildbot to
				# specify CROS_WORKON_COMMIT for all ebuilds, and update this
				# code path to fail and explain the problem.
				git clone -s "${path}" ${S} || die "Can't clone ${path}."
				fetched=true
			else
				git clone -sn "${path}" ${S} || die "Can't clone ${path}."
				if ! ( cd ${S} && git checkout -q ${CROS_WORKON_COMMIT} ) ; then
					ewarn "Cannot run git checkout ${CROS_WORKON_COMMIT} in ${S}."
					ewarn "Is ${path} up to date? Try running repo sync."
					ewarn "Falling back to git.eclass..."
					rm -rf ${S}/.git
				else
					fetched=true
				fi
			fi
			if $fetched; then
				VCSID=$(GIT_DIR="${path}/.git" git rev-parse HEAD)
				append-flags -DVCSID=\\\"${VCSID}\\\"
				return
			fi
		fi

		EGIT_REPO_URI="${repo}/${project}"
		EGIT_PROJECT="${project}"
		EGIT_COMMIT=${CROS_WORKON_COMMIT}
		if [[ "${CROS_WORKON_COMMIT}" = "master" ]]; then
			# TODO(davidjames): This code should really error out if
			# ${CROS_WORKON_COMMIT} is master, because it's going to be doing
			# the wrong thing for branches.
			ewarn "=== START HACK ALERT ==="
			ewarn "We don't have a CROS_WORKON_COMMIT for ${project},"
			ewarn "and we can't find what code to use, so we are using"
			ewarn "the latest version. This may break your build or"
			ewarn "produce wrong output. See http://crosbug.com/6506"
			ewarn "=== END HACK ALERT ==="
		fi
		# clones to /var, copies src tree to the /build/<board>/tmp
		git_src_unpack
		append-flags -DVCSID=\\\"${CROS_WORKON_COMMIT}\\\"
		return
	fi

	einfo "Using local source dir: $path"

	# Clone from the git host + repository path specified by
	# CROS_WORKON_REPO + CROS_WORKON_PROJECT. Checkout source from
	# the branch specified by CROS_WORKON_COMMIT into the workspace path.
	# If the repository exists just punt and let it be copied off for build.
	if [[ "${fetch_method}" == "local" && ! -d ${path} ]] ; then
		ewarn "Sources are missing in ${path}"
		ewarn "You need to cros_workon and repo sync your project. For example if you are working on the flimflam ebuild and repository:"
		ewarn "cros_workon start --board=x86-generic flimflam"
		ewarn "repo sync flimflam"
	fi

	# Copy source tree to /build/<board>/tmp for building
	local_copy "${path}" || \
		die "Cannot create a local copy"
	VCSID=$(GIT_DIR="${path}/.git" git rev-parse HEAD)
	append-flags -DVCSID=\\\"${VCSID}\\\"
}

cros-workon_pkg_info() {
	local CROS_WORKON_SRCDIR=$(get_path)

	for var in CROS_WORKON_SRCDIR CROS_WORKON_PROJECT ; do
		echo ${var}=\"${!var}\"
	done
}

EXPORT_FUNCTIONS src_unpack pkg_info

