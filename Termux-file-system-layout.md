Android OS normally does not provide a write access to system directories such as root file system ("/")
for the reasons of security and integrity of system files. This makes difficulties to follow the
[Filesystem Hierarchy Standard](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard) and Termux
has to use own.

## Packages installation root

All packages must install their data into this directory (installation prefix):
```
/data/data/com.termux/files/usr
```
For safety of user data, it is not allowed to create packages installing files outside of this directory.

We often refer to this path as `$PREFIX` or `$TERMUX_PREFIX`, latter is used within the context of packaging.

#### Termux file system hierarchy table

| Path                          | Purpose          |
|:------------------------------|:-----------------|
|`${TERMUX_PREFIX}/bin`         | Executables used by shell. Combines `/bin`, `/sbin`, `/usr/bin`, `/usr/sbin`.|
|`${TERMUX_PREFIX}/etc`         | Configuration files.|
|`${TERMUX_PREFIX}/include`     | C/C++ headers.|
|`${TERMUX_PREFIX}/lib`         | Shared objects (libraries), runtime executable data or development-related.|
|`${TERMUX_PREFIX}/libexec`     | Executables which should not be run by user directly.|
|`${TERMUX_PREFIX}/opt`         | Installation root for sideloaded packages.|
|`${TERMUX_PREFIX}/share`       | Non-executable runtime data and documentation.|
|`${TERMUX_PREFIX}/tmp`         | Temporary files. Erased on each application restart. Combines `/tmp` and `/var/tmp`. *Can be freely modified by user.*|
|`${TERMUX_PREFIX}/var`         | Variable data, such as caches and databases. *Can be modified by user, but with additional care.*|
|`${TERMUX_PREFIX}/var/run`     | Lock files, PID files, sockets and other temporary files created by daemons. Replaces `/run`.|

> Important: do not be confused by prefix directory `.../usr`. It has nothing to do with the real `/usr`
directory which you can find in Linux distributions. Termux never uses a secondary file system hierarchy
(`/usr`) for the packaging purposes.

All hardcoded references to FHS directories should be patched.

## Home directory

Termux home directory lives outside of the package installation prefix and is located at this path:
```
/data/data/com.termux/files/home
```

This is a place where all user data should be stored. As all application internal data is typically stored
on EXT4 or F2FS file system, it supports file access modes, executable permission and special files like
symbolic links.

Packages should never install files to the home directory. Exception is only for .deb file scripts, they
can be used to prepare initial configuration in $HOME for packages which can't do it on their own.

## Android directories

Android OS provides a number of directories, some of them are FHS-compliant. All system directories are
read-only and packages should never attempt to install or delete something in them.

| Path | Description                                       |
|------|---------------------------------------------------|
|`/`   | The root file system. Usually it is a ramdisk, but on modern Android OS versions it is a mounted system partition. Can be restricted by SELinux and not be viewable by `ls`.|
|`/bin`| Symbolic link to `/system/bin`. Do not add this to PATH to prevent clash of Termux tools with ones provided by Android.|
|`/dev`| Standard mount point for file system with device files. Access can be restricted by SELinux, though all important world-writable devices are accessible.|
|`/etc`| Symbolic link to `/system/etc`.|
|`/mnt`| Raw mount points of file systems with application and user data.|
|`/proc`| Standard directory with runtime process and kernel information. Typically mounted with `hidepid=2` option for privacy.|
|`/proc/net`| Networking interface statistics. Access restricted since Android 10 for privacy reasons.|
|`/sbin`| Directory where special-purpose executables (ADB daemon, dm-verity helper, modem nvram loader, etc). Access is restricted by SELinux and file modes. Do not add this directory to PATH.|
|`/storage`| Mounted user's storage volumes. Like `/mnt` but drive file systems are provisioned by `sdcardfs` daemon.|
|`/system`| The Android OS installation root.|
|`/system/bin`| A basic set of command line tools for system purposes and fully-functional ADB shell. Avoid adding this to PATH. Exceptions are allowed only for alternate executable paths, e.g. in case if package is not installed.|
|`/system/xbin`| Optional set of system command line tools. Content may vary between ROMs. Do not add this to PATH.|

---

&nbsp;





## File Path Limits

To choose the max file path length limits requires considering the limitations of Linux/Android. Linux assumes rootfs is at `/`, but for Termux, the rootfs directory needs to be under the app data directory path that android assigns the app, and hence it causes problems for linux system calls where buffer lengths are limited. Using [`PATH_MAX`](https://cs.android.com/android/platform/superproject/+/android-13.0.0_r18:bionic/libc/kernel/uapi/linux/limits.h;l=28) (`4096`) that is [defined by POSIX](https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/limits.h.html) is not possible for every Linux API.

The Termux apps and rootfs directory paths depends on:

- App data directory paths on Android are normally under `/data/data/<package_name>` for user `0`, or under `/data/user/<user_id>/<package_name>` or `/mnt/expand/<volume_uuid>/user/<user_id>/<package_name>` for secondary users. The `/mnt/expand` path is for apps installed on adoptable storage volumes, like external sd cards.
- The `package_name` on Android can be max `255` characters due to `ext4` filesystem limit as per [`NAME_MAX`](https://cs.android.com/android/platform/superproject/+/android-13.0.0_r18:bionic/libc/kernel/uapi/linux/limits.h;l=27) that is [defined by POSIX](https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/limits.h.html). ([1](https://cs.android.com/android/platform/superproject/+/android-13.0.0_r18:frameworks/base/core/java/android/content/pm/PackageParser.java;l=1601), [2](https://cs.android.com/android/platform/superproject/+/android-13.0.0_r18:frameworks/base/core/java/android/os/FileUtils.java;l=991), [3](https://cs.android.com/android/platform/superproject/+/android-13.0.0_r18:frameworks/base/services/core/java/com/android/server/pm/PackageInstallerSession.java;l=2757))
- The `volume_uuid` for an `/mnt/expand` path is equal to `36` characters in the format `VVVVVVVV-VVVV-VVVV-VVVV-VVVVVVVVVVVV`.
- A `user_id` can have a max `1000` value, so will use max `4` characters. ([1](https://cs.android.com/android/platform/superproject/+/android-14.0.0_r1:bionic/libc/bionic/grp_pwd.cpp;l=351), [2](https://cs.android.com/android/platform/superproject/+/android-14.0.0_r1:system/core/libcutils/multiuser.cpp;l=29)) For the primary user the value is `0` and for secondary users it is `>= 10`. Since only `1-10` users are allowed to be created normally, based on max of `fw.max_users` property or `config_multiuserMaximumUsers` config (`pm get-max-users`), this should only use 2 characters. ([1](https://source.android.com/docs/devices/admin/multi-user#applying_the_overlay), [2](https://cs.android.com/android/platform/superproject/+/android-14.0.0_r1:frameworks/base/core/res/res/values/config.xml;l=2802), [3](https://cs.android.com/android/platform/superproject/+/android-14.0.0_r1:frameworks/base/core/java/android/os/UserManager.java;l=5719))
- An app will normally put rootfs under a subdirectory of the app data directory. For Termux, this is currently the `files` (`5`) directory, but there are plans to move it to `termux/rootfs/II` (`16`) in future where `II` refers to rootfs id starting at `0` for multi-rootfs support. Termux forks may use a different path, so length may be lesser or higher.

&nbsp;

The path length of Termux apps and rootfs directory may cause the following problems:

- A filesystem socket ([pathanme UNIX domain socket](https://man7.org/linux/man-pages/man7/unix.7.html)) requires that the `sockaddr_un.sun_path` is limited to `108` characters including the null `\0` terminator as per [`UNIX_PATH_MAX`](https://cs.android.com/android/platform/superproject/+/android-13.0.0_r18:bionic/libc/kernel/uapi/linux/un.h;l=22)/`TERMUX__UNIX_PATH_MAX`. A filesystem socket is created by Termux app for [`termux-am-socket`](https://github.com/termux/termux-am-socket) for `termux-am` command under the Termux apps directory `/data/data/@TERMUX_APP__PACKAGE_NAME@/termux/apps` (not Termux rootfs directory). It's also planned to be used for Termux plugin apps for Termux APIs. Packages may create filesystem sockets in the `$TMPDIR` under the Termux rootfs directory.

- For the [`execve()`](https://man7.org/linux/man-pages/man2/execve.2.html) system call, the kernel imposes a maximum length limit on script [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)#Character_interpretation) including the `#!` characters at the start of a script. For Linux `< 5.1`, the limit is `128` characters and for Linux `>= 5.1`, the limit is `256` characters as per [`BINPRM_BUF_SIZE`](https://cs.android.com/android/kernel/superproject/+/0dc2b7de045e6dcfff9e0dfca9c0c8c8b10e1cf3:common/include/uapi/linux/binfmts.h;l=18) including the null `\0` terminator. ([1](https://cs.android.com/android/kernel/superproject/+/0dc2b7de045e6dcfff9e0dfca9c0c8c8b10e1cf3:common/fs/binfmt_script.c;l=34), [2](https://cs.android.com/android/kernel/superproject/+/0dc2b7de045e6dcfff9e0dfca9c0c8c8b10e1cf3:common/include/linux/binfmts.h;l=64)) **If `termux-exec` is set in [`LD_PRELOAD`](#ld_preload) and [`TERMUX_EXEC__INTERCEPT_EXECVE`](#termux_exec__intercept_execve) is enabled, then shebang limit is increased to `340` characters defined by `FILE_HEADER__BUFFER_LEN` (`TERMUX__ROOTFS_DIR_MAX_LEN + BINPRM_BUF_SIZE - 1`) defined in [`exec.h`](https://github.com/termux/termux-exec/blob/master/src/exec/exec.h) as shebang is read and script is passed to interpreter as an argument by `termux-exec` manually.** So if `LD_PRELOAD` will be set for all Termux shells, then this limit does not need to be worried about. Increasing limit to `340` also fixes issues for older Android kernel versions where limit is `128`. The limit is increased to `340`, because `BINPRM_BUF_SIZE` would be set based on the assumption that rootfs is at `/`, so we add Termux rootfs directory max length to it.

&nbsp;

Based on the above limitations and examples below, the following limits are chosen. **The limits are defined by [`properties.sh`](https://github.com/termux/termux-packages/blob/master/scripts/properties.sh) in `termux-packages`, [`TermuxCoreConstants`](https://github.com/termux/termux-app/blob/master/termux-shared/src/main/java/com/termux/shared/termux/core/TermuxCoreConstants.java) in `termux-app` and [`termux_files.h`](https://github.com/termux/termux-exec/blob/master/src/termux/termux_files.h) in `termux-exec`.**

```shell
TERMUX__APPS_DIR_MAX_LEN=84
TERMUX__APPS_APP_IDENTIFIER_MAX_LEN=11
TERMUX__ROOTFS_DIR_MAX_LEN=86
TERMUX__UNIX_PATH_MAX=108
```

For compiling Termux packages for `/data/data` or `/data/data/UU` paths, **ideally package name should be `<= 21` characters** and max `33` characters. If you have not yet chosen a package name, then it would be **best to keep it to `<= 10` characters**.
For compiling Termux packages for `/mnt/expand` paths or if it may be supported in future, keep package name at max `11` characters, but even that will only give `13` characters for a filesystem socket sub path under `$TMPDIR` and would require patching patches if a longer sub paths are used.

**If filesystem socket functionality is required for Termux apps, then Termux apps directory path length should be `<= 83` and if required for Termux packages, then Termux rootfs directory path length should be `<= 85`.**

The `TERMUX__APPS_DIR_MAX_LEN` is chosen as `84` based on the `12`, `13`, `14`, `16`, `17` and `18` examples below, which allow multiple unique filesystem sockets under apps directory for each unique app as long as apps directory length `<= 83`.

The `TERMUX__ROOTFS_DIR_MAX_LEN` is chosen as `86` based on the `37` and `41` examples below, which allow multiple unique filesystem sockets under `$TMPDIR` for each unique program as long as rootfs directory length `<= 85`, but would require patching patches that use longer paths under `$TMPDIR`.


&nbsp;

In the following examples:
- `V` refers to volume id.
- `U` refers to user id.
- `P` refers to Termux app package name.
- `I` refers to Termux rootfs id.
- `G` refers to plugin app package name that may call Termux app APIs.
- `N` refers to Termux app or plugin app identifier name limited to `TERMUX__APPS_APP_IDENTIFIER_MAX_LEN` (`11`) characters. For example `termux-xxxx`.
- `D` refers to a unique directory identifier template, like generated with [`mkstemp`](https://man7.org/linux/man-pages/man3/mkstemp.3.html) that requires minimum 6 `X` characters as template.
- `X` refers to a unique filename identifier template, like generated with [`mkstemp`](https://man7.org/linux/man-pages/man3/mkstemp.3.html) that requires minimum 6 `X` characters as template.
- `S` refers to a sub path.
- `/termux` refers to `TERMUX__ROOT_DIR` whose directory name with length `6` characters.
- `/termux/apps/n` refers to `TERMUX__APPS_DIR_BY_NAME` that are created for each app based on unique app identifier.
- `/termux/apps/p` refers to `TERMUX__APPS_DIR_BY_PACKAGE` that creates directories for each app based on package names or randomly generated unique identifier.
- `t` in `tXXXXXX` refers to type of socket, it may be `i` for a input socket and `o` for an output socket that belong to the same API call.

```shell
##### Apps filesystem sockets

1.  `/data/data/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/termux/apps/n/NNNNNNNNNNN/termux-am` (`path=82`,`package_name=35`)
2.  `/data/data/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/termux/apps/n/NNNNNNNNNNN/s/tXXXXXX` (`path=82`,`package_name=35`)
3.  `/data/data/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/termux/apps/p/GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG/s/tXXXXXX` (`path=107`,`package_name=35`,`plugin_package_name=36`)
4.  `/data/data/PPPPPPPPPPPPPPPPPPPPP/termux/apps/p/GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG/s/tXXXXXX` (`path=107`,`package_name=21`,`plugin_package_name=50`)
5.  `/data/data/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/termux/apps/n/NNNNNNNNNNN/termux-am` (`path=107`,`package_name=60`)
6.  `/data/data/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/termux/apps/n/NNNNNNNNNNN/s/tXXXXXX` (`path=107`,`package_name=60`)
7.  `/data/data/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/termux/apps/p/DDDDDD/s/tXXXXXX` (`path=107`,`package_name=65`)

8.  `/data/user/UU/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/termux/apps/n/NNNNNNNNNNN/termux-am` (`path=85`,`package_name=35`)
9.  `/data/user/UU/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/termux/apps/n/NNNNNNNNNNN/s/tXXXXXX` (`path=85`,`package_name=35`)
10. `/data/user/UU/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/termux/apps/p/GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG/s/tXXXXXX` (`path=107`,`package_name=33`,`plugin_package_name=35`)
11. `/data/user/UU/PPPPPPPPPPPPPPPPPPPPP/termux/apps/p/GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG/s/tXXXXXX` (`path=107`,`package_name=21`,`plugin_package_name=47`)
12. `/data/user/UU/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/termux/apps/n/NNNNNNNNNNN/termux-am` (`path=107`,`package_name=57`)
13. `/data/user/UU/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/termux/apps/n/NNNNNNNNNNN/s/tXXXXXX` (`path=107`,`package_name=57`)
14. `/data/user/UU/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/termux/apps/p/DDDDDD/s/tXXXXXX` (`path=107`,`package_name=62`)

15. `/mnt/expand/VVVVVVVV-VVVV-VVVV-VVVV-VVVVVVVVVVVV/user/UU/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/termux/apps/n/NNNNNNNNNNN/termux-am` (`path=128`,`package_name=35`) (**invalid**)
16. `/mnt/expand/VVVVVVVV-VVVV-VVVV-VVVV-VVVVVVVVVVVV/user/UU/PPPPPPPPPPPPPP/termux/apps/n/NNNNNNNNNNN/termux-am` (`path=107`,`package_name=14`)
17. `/mnt/expand/VVVVVVVV-VVVV-VVVV-VVVV-VVVVVVVVVVVV/user/UU/PPPPPPPPPPPPPP/termux/apps/n/NNNNNNNNNNN/s/tXXXXXX` (`path=107`,`package_name=14`)
18. `/mnt/expand/VVVVVVVV-VVVV-VVVV-VVVV-VVVVVVVVVVVV/user/UU/PPPPPPPPPP/termux/apps/p/GGGGGGGGGGGGGGG/s/tXXXXXX` (`path=107`,`package_name=10`,`plugin_package_name=15`)
19. `/mnt/expand/VVVVVVVV-VVVV-VVVV-VVVV-VVVVVVVVVVVV/user/UU/PPPPPPPPPPPPPPPPPPP/termux/apps/p/DDDDDD/s/tXXXXXX` (`path=107`,`package_name=19`)



##### $TMPDIR filesystem sockets (current rootfs)

20. `/data/data/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/files/usr/tmp/DDDDDD/XXXXXX` (`path=74`,`package_name=35`)
21. `/data/data/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/files/usr/tmp/DDDDDD/XXXXXX` (`path=107`,`package_name=68`)
22. `/data/data/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/files/usr/tmp/SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS` (`path=107`,`package_name=35`, `tmp_sub_path=46`)
23. `/data/data/PPPPPPPPPPPPPPPPPPPPP/files/usr/tmp/SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS` (`path=107`,`package_name=21`, `tmp_sub_path=60`)

24. `/data/user/UU/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/files/usr/tmp/DDDDDD/XXXXXX` (`path=77`,`package_name=35`)
25. `/data/user/UU/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/files/usr/tmp/DDDDDD/XXXXXX` (`path=107`,`package_name=65`)
26. `/data/user/UU/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/files/usr/tmp/SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS` (`path=107`,`package_name=35`, `tmp_sub_path=43`)
27. `/data/user/UU/PPPPPPPPPPPPPPPPPPPPP/files/usr/tmp/SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS` (`path=107`,`package_name=21`, `tmp_sub_path=57`)

28. `/mnt/expand/VVVVVVVV-VVVV-VVVV-VVVV-VVVVVVVVVVVV/user/UU/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/files/usr/tmp/DDDDDD/XXXXXX` (`path=120`,`package_name=35`) (**invalid**)
29. `/mnt/expand/VVVVVVVV-VVVV-VVVV-VVVV-VVVVVVVVVVVV/user/UU/PPPPPPPPPPPPPPPPPPPPPP/files/usr/tmp/DDDDDD/XXXXXX` (`path=107`,`package_name=22`)
30. `/mnt/expand/VVVVVVVV-VVVV-VVVV-VVVV-VVVVVVVVVVVV/user/UU/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/files/usr/tmp/S` (`path=108`,`package_name=35`, `tmp_sub_path=1`) (**invalid**)
31. `/mnt/expand/VVVVVVVV-VVVV-VVVV-VVVV-VVVVVVVVVVVV/user/UU/PPPPPPPPPPP/files/usr/tmp/SSSSSSSSSSSSSSSSSSSSSSSSS` (`path=107`,`package_name=11`, `tmp_sub_path=25`)

##### $TMPDIR filesystem sockets (future rootfs)

32. `/data/data/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/termux/rootfs/II/usr/tmp/DDDDDD/XXXXXX` (`path=85`,`package_name=35`)
33. `/data/data/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/termux/rootfs/II/usr/tmp/DDDDDD/XXXXXX` (`path=107`,`package_name=57`)
34. `/data/data/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/termux/rootfs/II/usr/tmp/SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS` (`path=107`,`package_name=35`, `tmp_sub_path=35`)
35. `/data/data/PPPPPPPPPPPPPPPPPPPPP/termux/rootfs/II/usr/tmp/SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS` (`path=107`,`package_name=21`, `tmp_sub_path=49`)

36. `/data/user/UU/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/termux/rootfs/II/usr/tmp/DDDDDD/XXXXXX` (`path=88`,`package_name=35`)
37. `/data/user/UU/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/termux/rootfs/II/usr/tmp/DDDDDD/XXXXXX` (`path=107`,`package_name=54`)
38. `/data/user/UU/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/termux/rootfs/II/usr/tmp/SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS` (`path=107`,`package_name=35`, `tmp_sub_path=32`)
39. `/data/user/UU/PPPPPPPPPPPPPPPPPPPPP/termux/rootfs/II/usr/tmp/SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS` (`path=107`,`package_name=21`, `tmp_sub_path=46`)

40. `/mnt/expand/VVVVVVVV-VVVV-VVVV-VVVV-VVVVVVVVVVVV/user/UU/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/termux/rootfs/II/usr/tmp/DDDDDD/XXXXXX` (`path=131`,`package_name=35`) (**invalid**)
41. `/mnt/expand/VVVVVVVV-VVVV-VVVV-VVVV-VVVVVVVVVVVV/user/UU/PPPPPPPPPPP/termux/rootfs/II/usr/tmp/DDDDDD/XXXXXX` (`path=107`,`package_name=11`)
42. `/mnt/expand/VVVVVVVV-VVVV-VVVV-VVVV-VVVVVVVVVVVV/user/UU/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/termux/rootfs/II/usr/tmp/S` (`path=119`,`package_name=35`, `tmp_sub_path=1`) (**invalid**)
43. `/mnt/expand/VVVVVVVV-VVVV-VVVV-VVVV-VVVVVVVVVVVV/user/UU/PPPPPPPPPPP/termux/rootfs/II/usr/tmp/SSSSSSSSSSSSS` (`path=107`,`package_name=11`, `tmp_sub_path=13`)



##### bin paths (current rootfs)

44. `/data/data/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/files/usr/bin/SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS` (`path=127`,`package_name=35`, `bin_sub_path=66`)
45. `/data/data/PPPPPPPPPPPPPPPPPPPPP/files/usr/bin/SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS` (`path=127`,`package_name=21`, `bin_sub_path=80`)

46. `/data/user/UU/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/files/usr/bin/SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS` (`path=127`,`package_name=35`, `bin_sub_path=43`)
47. `/data/user/UU/PPPPPPPPPPPPPPPPPPPPP/files/usr/bin/SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS` (`path=127`,`package_name=21`, `bin_sub_path=77`)

48. `/mnt/expand/VVVVVVVV-VVVV-VVVV-VVVV-VVVVVVVVVVVV/user/UU/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/files/usr/bin/SSSSSSSSSSSSSSSSSSSS` (`path=127`,`package_name=35`, `bin_sub_path=20`)
49. `/mnt/expand/VVVVVVVV-VVVV-VVVV-VVVV-VVVVVVVVVVVV/user/UU/PPPPPPPPPPP/files/usr/bin/SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS` (`path=127`,`package_name=11`, `bin_sub_path=44`)

##### bin paths (future rootfs)

50. `/data/data/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/termux/rootfs/II/usr/bin/SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS` (`path=127`,`package_name=35`, `bin_sub_path=55`)
51. `/data/data/PPPPPPPPPPPPPPPPPPPPP/termux/rootfs/II/usr/bin/SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS` (`path=127`,`package_name=21`, `bin_sub_path=69`)

52. `/data/user/UU/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/termux/rootfs/II/usr/bin/SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS` (`path=127`,`package_name=35`, `bin_sub_path=52`)
53. `/data/user/UU/PPPPPPPPPPPPPPPPPPPPP/termux/rootfs/II/usr/bin/SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS` (`path=127`,`package_name=21`, `bin_sub_path=66`)

54. `/mnt/expand/VVVVVVVV-VVVV-VVVV-VVVV-VVVVVVVVVVVV/user/UU/PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP/termux/rootfs/II/usr/bin/SSSSSSSSS` (`path=127`,`package_name=35`, `bin_sub_path=9`)
55. `/mnt/expand/VVVVVVVV-VVVV-VVVV-VVVV-VVVVVVVVVVVV/user/UU/PPPPPPPPPPP/termux/rootfs/II/usr/bin/SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS` (`path=127`,`package_name=11`, `bin_sub_path=33`)
```
