[![asciicast](https://asciinema.org/a/5BsCbNoCzNFEgcH8vh8975MLm.svg)](https://asciinema.org/a/5BsCbNoCzNFEgcH8vh8975MLm?autoplay=1&speed=2.5)

# Building Packages

Once the build environment has been properly [set up](./Build-environment), then packages can be built with the [`build-package.sh`] script located at the root of [`termux-packages`] repository with one or more package names as arguments.

- The default build architecture is `aarch64`, which can be overridden with the [`-a`](#-a) flag.
- If only a package needs to be built, it is recommended to pass the [`-I`](#-i-1) flag so that its dependencies are not built and are downloaded from termux packages repo instead, as building dependencies would generally take a lot of time.
- If a package has already been built, and it needs to be rebuilt, pass the [`-f`](#-f) flag. Optionally, the [`-r`](#-r) flag should be passed if the package sources should be re-downloaded during rebuild.
- Passing only the [`-f`](#-f) and [`-I`](#-i-1) flags is normally sufficient to build a package being tested or developed.
- To build a package whose sources exist on the local filesystem, instead of a remote source URL that is defined in the `$TERMUX_PKG_SRCURL` variable of the `build.sh` file of each package, check [Build Local Package](#build-local-package) docs.

### Contents

- [Build Examples](#build-examples)
- [Build Command Options](#build-command-options)
- [Build Command Config](#build-command-config)
- [Build Process](#build-process)
- [Build Steps](#build-steps)
- [Build Local Package](#build-local-package)

---

&nbsp;





## Build Examples

##### To build the `bash` package, and all its dependencies, for the `aarch64` architecture

```shell
./build-package.sh bash
```

##### To build the `bash` package, but download instead of building its dependencies, for the `aarch64` architecture

```shell
./build-package.sh -I bash
```

##### To force build the `bash` package even if its already built, but download instead of building its dependencies, for the `aarch64` architecture

```shell
./build-package.sh -f -I bash
```

##### To force build the `bash` package and all its dependencies even if they are already built, for the `aarch64` architecture

```shell
./build-package.sh -F bash
```

##### To build the `bash` package, and all its dependencies, for the `arm` architecture

```shell
./build-package.sh -a arm bash
```

##### To build the `bash`, `coreutils` and `grep` packages, and all their dependencies, for the `aarch64` architecture

```shell
./build-package.sh bash coreutils grep
```

---

&nbsp;





## Build Command Options

The following command options are supported by `build-package.sh`.

#### `-a`

The architecture to build for. Valid values are: `aarch64`, `arm`, `i686`, `x86_64`. Default is `aarch64`. For on-device builds, the architecture is determined automatically and this option is not available.



#### `-c`

Continue previous build. This skips the source extraction, patching and the configure step, and goes straight to `termux_step_make`. Only works if normal build has already been run and it fails, or build was stopped during `termux_step_make` or later.

This is useful when working on a big package that can take hours to build, as it is convenient to be able to build until there is an error, then apply some new patch (manually) to the source, and then continue from where the last build failed.



#### `-d`

Build with debug information and turn of compiler optimizations.



#### `-D`

Build disabled package, i.e. located in directory `./disabled-packages`.



#### `-f`

Force build package even if it already built or installed.

See also [`-F`](#-f-1) and [`-r`](#-r) flags.



#### `-F`

Force build package and all its dependencies even if they are already built or installed.

See also [`-f`](#-f) and [`-r`](#-r) flags.



#### `-i`

Download dependencies of the build packages defined in `$TERMUX_PKG_DEPENDS` variable of their [`build.sh` file](./Creating-new-package) from Termux [package repositories](https://packages.termux.dev) instead of building them locally. Erases data in `$TERMUX__PREFIX` and `/data/data/.built-packages` files for all packages before starting build. Not available for on-device builds.

This will be **ignored** if compiling a package for different core variable values, like for `$TERMUX_APP__PACKAGE_NAME` or `$TERMUX__PREFIX`, than the values for which the packages hosted in the packages repository were compiled for. Check `$TERMUX_REPO_*` variables in [`properties.sh`] and [Build Command Config](#build-command-config) docs for more info.

See also [`-I`](#-i-1) flag.



#### `-I`

Download dependencies of the build packages defined in `$TERMUX_PKG_DEPENDS` variable of their [`build.sh` file](./Creating-new-package) from Termux [package repositories](https://packages.termux.dev) instead of building them locally. Unlike [`-i`](#-i) option, this will not erase data in `$TERMUX__PREFIX` and `/data/data/.built-packages` files for all packages, and is available for on-device builds.

This will be **ignored** if compiling a package for different core variable values, like for `$TERMUX_APP__PACKAGE_NAME` or `$TERMUX__PREFIX`, than the values for which the packages hosted in the packages repository were compiled for. Check `$TERMUX_REPO_*` variables in [`properties.sh`] and [Build Command Config](#build-command-config) docs for more info.

See also [`-i`](#-i) flag.



#### `-o`

Specify directory where to place built package files (`*.deb`/`*.pkg.tar.xz`). Default is `./output`.



#### `-q`

Pass necessary arguments to `make` or similar tool to make build quietly. May not work for all packages.



#### `-r`

Remove all package build dependent directories that [`-f`](#-f)/[`-F`](#-f-1) flags alone would not remove. This includes the package cache directory (`$TERMUX_PKG_CACHEDIR`) containing package sources and host build directory (`$TERMUX_PKG_HOSTBUILD_DIR`). The `-r` flag will be ignored if [`-f`](#-f)/[`-F`](#-f-1) flags are not passed.

With [`-f`](#-f)/[`-F`](#-f-1) flags alone, latest package sources will not be re-downloaded on rebuilds if `$TERMUX_PKG_SRCURL` refers to `git+` URL, i.e for a branch (like `master`) that's being continuously updated on a remote git repository (`git+https://`) or in a local git repository directory (`git+file://`) (where any new changes must also be committed to branch to be downloaded).



#### `-s`

Skip dependency check.



#### `-w`

Install dependencies without version binding.



#### `--format`

Specify format of built packages. Valid values are: `debian` (default) and `pacman`.



#### `--library`

Specify library of package. Valid values are: `bionic` and `glibc`

---

&nbsp;





## Build Command Config

The variables for which Termux packages are compiled for are sourced by the [`build-package.sh`] script from the [`properties.sh`] file.

Some of the core variables are `$TERMUX_APP__PACKAGE_NAME`, `$TERMUX_APP__DATA_DIR`, `$TERMUX__PROJECT_DIR`, `$TERMUX__CORE_DIR`, `$TERMUX__APPS_DIR`, `$TERMUX__ROOTFS`, `$TERMUX__HOME`, and `$TERMUX__PREFIX` so that Termux packages work in the app data directory assigned by Android to the Termux app. **If the values are changed**, like if forking to compile packages for a different app package name, then packages hosted by Termux [package repositories](https://packages.termux.dev) cannot be used, like with [`-i`](#-i)/[`-I`](#-i-1) flags. **All packages will need to be compiled for the custom app package name manually** and optionally hosted on custom packages repository if required. **Packages cannot be mixed with the ones with a different app package name, like `com.termux` and a custom one, as packages will likely not work at runtime**. Check `$TERMUX_REPO_*` variables in [`properties.sh`] for more info.

&nbsp;

The following environment variables affect behaviour of Termux build system.

#### `TERMUX_TOPDIR`

Specifies the base directory for Termux build environment. Standalone toolchain, downloaded sources, package build directories will be created here. Default is `$HOME/.termux-build`.



#### `TERMUX_PKG_MAKE_PROCESSES`

Specifies amount of jobs that should be spawned by utility `make`. Default is output of command `nproc`.



#### `TERMUX_PKG_API_LEVEL`

Specifies [Android API level](https://developer.android.com/tools/releases/platforms) against which packages will be compiled. Default is `24` (Android `7`) for `master` branch and `21` (Android `5`) for `android-5` branch.



#### `TERMUX_PKG_MAINTAINER`

Specifies a value that should be written to package's maintainer field. Default is `@termux`.



#### `TERMUX_PACKAGES_DIRECTORIES`

Specifies a root directory of package tree. Default is `packages`.

&nbsp;

The following variables are overridden with [command options](#build-command-options) passed to the [`build-package.sh`] script.

#### `TERMUX_ARCH`

Specifies CPU architecture for which packages should be cross-compiled. Default is `aarch64`. Cannot be changed when building on device.



#### `TERMUX_CONTINUE_BUILD`

If set, build will skip source extraction and configure step and go straight to `termux_step_make`.



#### `TERMUX_DEBUG_BUILD`

Perform debug build. Debug information won't be stripped from binaries and compiler optimizations will be turned off.



#### `TERMUX_INSTALL_DEPS`

If set to `true`, then dependencies will be installed from the package repositories rather than built.



#### `TERMUX_RM_ALL_PKGS_BUILT_MARKER_AND_INSTALL_FILES`

Special option for use with `$TERMUX_INSTALL_DEPS`. If set to `false`, then Termux system root will not be wiped before extracting dependencies. When building on device, this variable should always be `false`.



#### `TERMUX_QUIET_BUILD`

If set, additional arguments will be passed to utility `make` to reduce output in compilation process.



#### `TERMUX_SKIP_DEPCHECK`

If set, then no dependency checks will be done.



#### `TERMUX_OUTPUT_DIR`

Path to directory where built package files (`*.deb`/`*.pkg.tar.xz`) will be placed.

---

&nbsp;





## Build Process

Build starts at the moment of execution of `./build-package.sh` script and is split into the following stages (environment initialization steps are omitted):

1. Source the `./packages/$TERMUX_PACKAGE_NAME/build.sh` file to obtain metadata such like version, description, dependencies, source URL and package-specific build steps.

2. In case if `build-package.sh` got arguments `-i` or `-I`, download package files (`*.deb`/`*.pkg.tar.xz`) from package repositories and extract to `$TERMUX__PREFIX`. Otherwise obtain the dependency build order from script `./scripts/buildorder.py` and execute `./build-package.sh` with argument `-s` for each dependency package.

3. Create timestamp file which will be used later.

4. Download package's source code from the URL and verify its SHA-256 checksum. Then extract source code to `$TERMUX_PKG_SRCDIR`. This step is omitted if `$TERMUX_PKG_SKIP_SRC_EXTRACT` is set.

5. Build package for the host. This step is performed only when `$TERMUX_PKG_HOSTBUILD` is set.

6. Set up a standalone Android NDK toolchain and apply NDK sysroot patches. This step is performed only one time.

7. Search for patches in `./packages/$TERMUX_PKG_NAME/*.patch` and apply them.

8. Configure and compile source code for specified `$TERMUX_ARCH`.

9. Install everything into `$TERMUX__PREFIX`.

10. Determine files which are modified from time when timestamp file was created (step 3) and extract them into `$TERMUX_TOPDIR/$TERMUX_PKG_NAME/massage`.

11. Strip binaries (if non-debug build), gzip manpages, delete unwanted files and fix permissions. Distribute files between subpackages if needed.

12. Archive package data into package files (`*.deb`/`*.pkg.tar.xz`) ready for distribution.

---

&nbsp;





## Build Steps

Order specifies function sequence. 0 order specifies utility functions.

Suborder specifies a function triggered by the main function. Functions with
different suborders are not executed simultaneously.

| Order | Function Name | Overridable | Description |
| -----:|:-------------:| -----------:|:----------- |
| 0.1   | `termux_error_exit` | no | Stop script and output error. |
| 0.2   | `termux_download` | no | Utility function to download any file. |
| 0.3   | `termux_setup_golang` | no | Setup Go Build environment. |
| 0.4   | `termux_setup_cmake` | no | Setup CMake configure system. |
| 0.5   | `termux_setup_ninja` | no | Setup Ninja make system. |
| 0.6   | `termux_setup_meson` | no | Setup Meson configure system. |
| 0.7   | `termux_setup_protobuf` | no | Setup Protobuf compiler. |
| 0.8   | `termux_setup_rust` | no | Setup Cargo Build. |
| 0.9   | `termux_setup_ghc_cross_compiler` | no | Setup ghc cross-compiler targeting Android. |
| 0.10  | `termux_setup_ghc` | no | Setup ghc compiler for host build. |
| 0.11  | `termux_setup_jailbreak_cabal` | no | Setup `jailbreak-cabal` utility. It is used to remove version constraints from Haskell (with cabal build system)
| 1     | `termux_step_setup_variables` | no | Setup essential variables like directory locations and flags. |
| 2     | `termux_step_handle_buildarch` | no | Determine architecture to build for. |
| 3     | `termux_step_setup_build_folders` | no | Delete old src and build directories if they exist. |
| 4     | `termux_step_start_build` | no | Initialize build environment. Source package's `build.sh`. |
| 5     | `termux_step_get_dependencies` | no | Download or build specified dependencies of the package. |
| 5.1   | `termux_step_get_repo_files` | no | Fetch package repositories information when `-i` or `-I` option was supplied. |
| 5.2   | `termux_extract_dep_info` | no | Obtain package architecture and version for downloading. |
| 6     | `termux_step_create_timestamp_file` | no | Make timestamp to determine which files have been installed by the build. |
| 5.3   | `termux_download_deb_pac` | no | Download dependency package files (`*.deb`/`*.pkg.tar.xz`) for installation. |
| 6     | `termux_step_get_source` | yes | Obtain package source code and put it in `$TERMUX_PKG_SRCDIR`. |
| 7.1   | `termux_git_clone_src` | no | Obtain source by git clone, is run if `$TERMUX_PKG_SRCURL` ends with ".git". |
| 7.2   | `termux_download_src_archive` | no | Download zip or tar archive with package source code. |
| 7.3   | `termux_unpack_src_archive` | no | Extract downloaded archive into `$TERMUX_PKG_SRCDIR`. |
| 8     | `termux_step_post_get_source` | yes | Hook to run commands immediately after obtaining source code. |
| 9     | `termux_step_handle_host_build` | yes | Determine whether a host build is required. |
| 9.1   | `termux_step_host_build` | yes | Perform a host build. |
| 10     | `termux_step_setup_toolchain` | no | Setup NDK standalone toolchain. |
| 11    | `termux_step_patch_package` | no | Apply to source code all `*.patch` files located in package's directory. |
| 12    | `termux_step_replace_guess_scripts` | no | Replace `config.sub` and `config.guess` scripts. |
| 13    | `termux_step_pre_configure` | yes | Hook to run commands before source configuration. |
| 14    | `termux_step_configure` | yes | Configure sources. By default, it determines build system automatically. |
| 14.1  | `termux_step_configure_haskell_build` | no | Haskell packages build configuration. |
| 14.2  | `termux_step_configure_autotools` | no | Autotools build configuration. |
| 14.3  | `termux_step_configure_cmake` | no | CMake build configuration. |
| 14.4  | `termux_step_configure_meson` | no | Meson build configuration. |
| 15    | `termux_step_post_configure` | yes | Hook to run commands immediately after configuration. |
| 16    | `termux_step_make` | yes | Compile the source code. |
| 17    | `termux_step_make_install` | yes | Install the compiled artifacts. |
| 18    | `termux_step_post_make_install` | yes | Hook to run commands immediately after installation. |
| 19    | `termux_step_install_service_scripts` | yes | Installs scripts for termux-services |
| 20    | `termux_step_install_license` | yes | Link or copy package-specific LICENSE to `./share/doc/$TERMUX_PKG_NAME`. |
| 21    | `termux_step_extract_into_massagedir` | no with `make_install` | Extract files modified in `$TERMUX__PREFIX`. |
| 22    | `termux_step_massage` | no | Strip binaries, remove unneeded files. |
| 22.1  | `termux_create_debian_subpackages` | no | Creates all subpackages (debian format). |
| 22.2  | `termux_create_pacman_subpackages` | no | Creates all subpackages (pacman format). |
| 24    | `termux_step_post_massage` | yes | Final hook before creating package file(s) (`*.deb`/`*.pkg.tar.xz`). |
| 25    | `termux_step_create_debian_package` | no | Create debian package file (`*.deb`). |
| 25.1  | `termux_step_create_pacman_package` | no | Create pacman package file (`*.pkg.tar.xz`). |
| 25.2  | `termux_step_create_debscripts` | yes | Create maintainer scripts, e.g. pre/post installation hooks. |
| 25.3  | `termux_step_create_pacman_install_hook` | no | Convert result of `termux_step_create_debscripts` to pacman-compatible format. |
| 26    | `termux_step_finish_build` | no | Notification of finish. |

---

&nbsp;





## Build Local Package

The [`build-package.sh`] script can also be used to build a package whose sources exist on the local filesystem, instead of remote source URLs that is defined in the `$TERMUX_PKG_SRCURL` variable of the `build.sh` file of each package.

This can also be used to:
- Test a new package before submission to the `termux-packages` repo, by creating a local directory for its (upstream) sources.
- Test the changes that were made to an existing package after downloading its source locally, like `git` cloning its upstream repo.
- Test pull requests sent to a package's upstream git repository, by `git` cloning its repo and building the pull request branch locally.

&nbsp;

### 1. Clone termux-packages repo to build local package

Clone and change current working directory to it.

```shell
git clone https://github.com/termux/termux-packages.git
cd termux-packages
```

## &nbsp;



### 2. Modify `build.sh` of the local package

The `$TERMUX_PKG_SRCURL` in the `build.sh` file of the package must be be set to the local filesystem path/URL for where to download the package sources from for building the package.

It must be set in the `file:///path/to/source/dir`, `file:///path/to/source/file` or `git+file:///path/to/source/git/dir` formats, and all formats have their own build time behaviour and whatever is chosen will affect how the local source file or directory should to be created in step `3` below. **Check the [Package Build Local Source URLs](./Creating-new-package#package-build-local-source-urls) docs for more info. Note that 3 forward slashes `/` are necessary and `file://path` is not a valid URL.** The path must also be normalized with no duplicate or trailing path separators `/`.

**It is recommended to use the `file:///path/to/source/dir` format** as:
- Any uncommitted changes will get built automatically.
- The [`-r`](#-r) option will not need to be passed to re-download the sources on rebuilds.
- An `tar`/`zip` archive of a local source directory will not have to manually created.
- It wouldn't matter if the local `git` source directory was originally cloned with a `https` or `ssh` (`git@`) `origin` URL.
- However, if `$TERMUX_PKG_GIT_BRANCH` variable is set in the `build.sh` of the package, then the branch set will have to manually checkout out.

The `build.sh` file for a package exist under the `<repo_channel>/<package_name>` directory in the `termux-packages` repo root directory where `repo_channel` refers to the repository `channel` of the package, whose directory is specified in the [`repo.json`](https://github.com/termux/termux-packages/blob/master/repo.json) file. For our example, we use the `main` channel for the `foo` package, so its path would be `packages/foo/build.sh`.

If creating a new package, check the [Package Build Config](./Creating-new-package) and [Package Build Script](./Creating-new-package#package-build-script) docs for info on the paths for `build.sh` files and what they should contain.

The `/home/builder/termux-packages` path below is the path in the [`termux-packages` docker container] where the `termux-packages` repo directory is mounted at and `sources/foo` under it is where the local source directory or file must be created in step `3`.

```shell
# packages/foo/build.sh

TERMUX_PKG_SRCURL=file:///home/builder/termux-packages/sources/foo
TERMUX_PKG_SHA256=SKIP_CHECKSUM # May not be needed for source file format. 
```

## &nbsp;



### 3. Create source for local package

Create a source directory or file on the local filesystem for the package that needs to be compiled.

If building inside the [`termux-packages` docker container], like off-device, then the **source must be under the `termux-packages` repo root directory**, otherwise it will not be mounted inside the `docker` container and wouldn't exist (No, a symlink to an outside directory will not work, but there are [ways](https://stackoverflow.com/a/77944759/14686958) to mount directories into  the mount namepsace of an existing docker `bash` process, which is planned to be supported in future). Termux reserves the `sources` sub directory for local source directories, but a different directory can be used too, but it will require making appropriate changes to commands below.

Make sure current working directory is the root directory of `termux-packages` repo directory before running below commands.

For example, for a package named `foo`, we create its local source at `sources/foo`. Replace `foo` in `sources/foo` with required package name in below commands.

The following ways may be used to get/create the source depending on the format used in `$TERMUX_PKG_SRCURL` in step `2`, as per [Package Build Local Source URLs](./Creating-new-package#package-build-local-source-urls) docs.

- **`file:///path/to/source/dir` URL** format.
    - Clone the `git` repo for an existing package. Replace `https://github.com/termux/foo.git` with required package's repo `git` url.

        ```shell
        # Git clone the repo
        mkdir -p sources
        git clone https://github.com/termux/foo.git sources/foo

        # (OPTIONAL) Manually switch to different (pull) branch that
        # exists on origin if required, or to the one defined in
        # $TERMUX_PKG_GIT_BRANCH variable of build.sh file, as it will
        # not be automatically checked out.
        # By default, the repo default/current branch that's cloned
        # will get built, which is usually `master` or `main`.
        # Whatever is the current state of the source directory will
        # be built as is, including any uncommitted changes to current
        # branch.
        (cd sources/foo; git checkout <branch_name>)
        ```

    - Download a release source `tar` for an existing package and extract it to source directory. Replace `https://github.com/termux/foo/archive/<release_version>.tar.gz` with required package's release `tar.gz` url. The source files must be extracted directly under the `sources/foo` directory, and not a sub directory, like `sources/foo/foo-v0.1.0`, this is why the `--strip-components=1` is passed as GitHub release source `tar` contain a versioned sub directory at `tar` root.

        ```shell
        # Download and extract source tar
        mkdir -p sources/foo
        curl -sL https://github.com/termux/foo/archive/<release_version>.tar.gz | tar xzf - -C sources/foo --strip-components=1
        ```

    - Create a source directory for a new package and then manually create source files under it that need to be built. Optionally, to initialize a new local [`git`] repository, run the [`git init`](https://git-scm.com/docs/git-init) command.

        ```shell
        mkdir -p sources/foo
        ```

- **`file:///path/to/source/file` URL** format.
    - Download a release source `tar` for an existing package at source path. Replace `https://github.com/termux/foo/archive/<release_version>.tar.gz` with required package's release `tar.gz` url.

        ```shell
        # Download source tar
        rm -f sources/foo
        curl -L https://github.com/termux/termux-am-socket/archive/refs/tags/1.5.0.tar.gz -o sources/foo
        ```
    - Creating a `tar`/`zip` archive of some local source files manually with some special logic. Preferable, `$TERMUX_PKG_SHA256` variable should be set to `SKIP_CHECKSUM` in `build.sh` of package so that checksum is not checked and the archive gets re-downloaded every time on rebuilds.

- **`git+file:///path/to/source/git/dir` URL** format.
    - To clone the `git` repo for an existing package. Replace `https://github.com/termux/foo.git` with required package's repo `git` url. **The repo must be cloned with a `https` URL instead of a `ssh` (`git@`) URL** if building with [`termux-packages` docker container] and `$TERMUX_PKG_GIT_BRANCH` is set.

        ```shell
        # Git clone the repo
        mkdir -p sources
        git clone https://github.com/termux/foo.git sources/foo

        # (OPTIONAL) Manually switch to different (pull) branch that
        # exists on origin if required.
        # By default, if $TERMUX_PKG_GIT_BRANCH variable of build.sh
        # file is set, then that branch will automatically be checked
        # out, otherwise the repo default/current branch that's cloned
        # will get built, which is usually `master` or `main`.
        (cd sources/foo; git checkout <branch_name>)

        # (OPTIONAL) Any uncommitted changes to current branch will NOT
        # get built and will need to be committed.
        git add -A && git commit -m "latest changes"
        ```
## &nbsp;



### 4. Build local package with `build-package.sh`

Run the `build-package.sh` script to build the `foo` package.

The following arguments are passed:

- [`-f`](#-f) flag to force rebuild the package even if its already built. Optionally, this may not be passed if package does not need to be rebuilt.
- [`-I`](#-i-1) flag so that dependencies of the `foo` package are downloaded from Termux [package repositories](https://packages.termux.dev) instead of being built locally, as that would be time consuming. Optionally, this may not be passed if package dependencies should be built locally as well.
- `foo` as the package name argument.

The following arguments may need to be passed:

- [`-r`](#-r) flag if to re-download the local package `git` directory during rebuild, if `git+file:///path/to/source/git/dir` formatted URL is set in `$TERMUX_PKG_SRCURL`, otherwise new changes to local sources since first download will not get built.

```shell
# Run termux-packages docker container if running off-device 
./scripts/run-docker.sh

# Build package
./build-package.sh -f -I foo
```

---

&nbsp;





[`build-package.sh`]: https://github.com/termux/termux-packages/blob/master/build-package.sh
[`git`]: https://git-scm.com/docs/git
[`properties.sh`]: https://github.com/termux/termux-packages/blob/master/scripts/properties.sh
[`termux-packages`]: https://github.com/termux/termux-packages
[`termux-packages` docker container]: ./Build-environment#docker-container
