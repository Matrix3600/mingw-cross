#!/usr/bin/env bash

function get_build_machine_type()
{
	if [ "$OS" == "Windows_NT" ]; then
		local system="win"
	else
		local system="linux"
		case $(uname -s) in
			Linux) ;;
			Darwin) system="macos" ;;
			*) echo "uname -s: \"$(uname -s)\"" >&2 ;;
		esac
	fi
	local arch="unknown"
	case $(uname -m) in
		i?86) arch="x86" ;;
		x86_64|amd64) arch="x64" ;;
		aarch64*|arm64|armv8*) arch="arm64" ;;
		*) echo "uname -m: \"$(uname -m)\"" >&2 ;;
	esac
	printf '%s\n' "${system}-${arch}"
}


function build_crosstool_ng()
{
	sudo rm -rf crosstool-ng
	mkdir crosstool-ng
	local install_dir="$(pwd)/crosstool-ng"

	pushd builder

	# Patch
	git clean -fdx
	git reset --hard HEAD
	if [ -d "../patches" ]; then
		find "../patches" -type f -name "*.patch" -print0 | sort -z | \
			while IFS= read -r -d '' file; do
				echo "*** ${file#../patches/}"
				patch -Np1 -i "$file"
			done
	fi

	./bootstrap
	./configure --prefix="${install_dir}"
	make -j$(nproc)
	make install
	popd
	sudo chown -R root:0 crosstool-ng

	local name="crosstool-ng.tar.xz"

	show_progress_message "Creating \"${name}\""

	tar -cJvf "$name" crosstool-ng
	sudo rm -rf crosstool-ng
}


function show_progress_message()
{
	echo
	echo "***"
	echo "*** $1"
	echo "***"
	echo
}
