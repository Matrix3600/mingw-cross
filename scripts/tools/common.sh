#!/usr/bin/env bash

CROSS_GNU_URL="https://github.com/Matrix3600"
CROSS_GNU_VER="20260908"
CROSS_MINGW_URL="https://github.com/Matrix3600"
CROSS_MINGW_VER="20260810"


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


function get_host_type()
{
	local HOST="$1"

	local host_type
	host_type="$(sed 's/-unknown//g' <<< "$HOST")"
	case $host_type in
		aarch64-linux-gnu)
			host_type="linux-arm64" ;;
		aarch64-w64-mingw32)
			host_type="win-arm64" ;;
		riscv64-linux-gnu)
			host_type="linux-riscv64" ;;
		x86_64-linux-gnu)
			host_type="linux-x64" ;;
		x86_64-w64-mingw32)
			host_type="win-x64" ;;
	esac
	printf '%s\n' "$host_type"
}


function show_progress_message()
{
	echo
	echo "***"
	echo "*** $1"
	echo "***"
	echo
}
