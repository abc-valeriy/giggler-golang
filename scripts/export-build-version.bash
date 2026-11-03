#!/usr/bin/env bash

# The script exports the build version for the project.
# The build version can be one of the following:
# - `unknown`: if git or the repository isn't available
# - `<commit>-dirty`: if the working directory has uncommitted changes
# - `<commit>`: if the current commit is not tagged
# - `<tag>`: if the current commit is tagged

export-build-version() {
	commitVersion=$(git rev-parse --short=4 HEAD)
	tagVersion=$(git tag --points-at HEAD | head -n1)

	if [[ -z "$commitVersion" && -z "$tagVersion" ]]; then
		export GIGGLER_GOLANG_VERSION="unknown"
		return
	fi

	if [[ -n "$(git status --porcelain)" ]]; then
		export GIGGLER_GOLANG_VERSION="${commitVersion}-dirty"
		return
	fi

	if [[ -n "$tagVersion" ]]; then
		export GIGGLER_GOLANG_VERSION="${tagVersion}"
		return
	fi

	export GIGGLER_GOLANG_VERSION="${commitVersion}"
}
