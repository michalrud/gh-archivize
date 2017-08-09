#!/bin/bash

API_URL="https://api.github.com"
USERNAME=$1
COMPRESSION_TOOL="7za a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on -sdel"
COMPRESSION_EXT=".7z"
TMPDIR="./.tmp"
REQS="curl jq git 7za"

function check_reqs {
	failed_deps=false
	for req in ${REQS}; do
		which $req > /dev/null
		if [ $? -ne 0 ]; then
			failed_deps=true;
			echo "Missing dependency: ${req}";
		fi
	done
	if [ "$failed_deps" = true ]; then
		echo "Aborting."
		exit 1
	fi
}

function main {
	REPO_INFO=$(curl "${API_URL}/users/${USERNAME}/repos" | jq -c '.[] | {name: .name, clone_url: .clone_url}')
	mkdir $TMPDIR
	pushd $TMPDIR

	for repo in $REPO_INFO; do
		REPO_NAME=$(echo $repo | jq -re '.name')
		if [[ $? -ne 0 ]] ; then continue; fi
		REPO_URL=$(echo $repo | jq -re '.clone_url')
		if [[ $? -ne 0 ]] ; then continue; fi
		git clone $REPO_URL $REPO_NAME
		$COMPRESSION_TOOL "../${REPO_NAME}${COMPRESSION_EXT}" "${REPO_NAME}"
	done

	popd
	rm -rf $TMPDIR
}

check_reqs
main
