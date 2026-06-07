# mingw-cross

This is a simple and lightweight project for making a cross-compilation
toolchain with the GCC compiler and the MinGW-w64 library.

These [ready-to-use](https://github.com/Matrix3600/mingw-cross/releases) toolchains run on:

- Linux x86-64

## Supported targets

| Target                         | GCC    | Binutils | MinGW-w64 |
|--------------------------------|:------:|:--------:|:---------:|
| aarch64-w64-mingw32            | 16.1.0 | 2.46     | 14.0.0    |
| i686-w64-mingw32               | 16.1.0 | 2.46     | 14.0.0    |
| x86_64-w64-mingw32             | 16.1.0 | 2.46     | 14.0.0    |

## How to use

Download the tarball from the [release page](https://github.com/Matrix3600/mingw-cross/releases).
Choose the one that corresponds to the `host` system on which the toolchain will run, and the `target` for which you want to generate executables (from the list above).

The tarball names are `<host>_<target>.tar.xz` for Linux,
or `<host>_<target>.7z` for Windows.

On Linux, extract the tarball to `/opt/x-tools`:
```
sudo mkdir -p /opt/x-tools
sudo tar -xf <host>_<target>.tar.xz -C /opt/x-tools

export PATH="/opt/x-tools/<target>/bin:$PATH"
<target>-gcc hello.c -o hello
```

On Windows, extract it to `C:\x-tools`:
```
mkdir C:\x-tools
tar -xf <host>_<target>.7z -C C:\x-tools
PATH=C:\x-tools\<target>\bin;%PATH%
<target>-gcc hello.c -o hello
```

## How to build

Fork this project, activate Github Actions for the repository, and create a new tag for the release:

```
git tag <tag_name>
git push origin <tag_name>
```
This builds the files and creates a draft release.

The host architecture (on which the toolchains run) depends on the beginning of the tag name:
- "x64-" for Linux x86-64

Otherwise you can also publish a release directly.

Or build manually for your machine's architecture:
```
./scripts/make <target>
```

## License

MIT

## Acknowledgements

We would like to express our gratitude to the following individuals and projects:

- [cross-tools](https://github.com/cross-tools)
- [crosstool-ng](https://github.com/crosstool-ng/crosstool-ng)
- [mingw-w64](https://www.mingw-w64.org)
