# Info for mirror maintainers

On `10th` of December `2022` we moved the primary termux packages repository (https://packages.termux.dev) from FossHost to [Hetzner](https://www.hetzner.com/cloud). Now the repository is accessible over both IPv4 and IPv6, and `rsync` can be used to mirror the main repository. The page [How to mirror the official repositories](https://github.com/termux/termux-packages/wiki/How-to-mirror-the-official-repositories) has suggestions for how to mirror our repositories.

The `unstable-packages`, `game-packages` and `science-packages` channels have been merged into the `termux-main` channel and do not need to be synced any longer.

* Mirror Size (full): 27.57GB (as of June 2025)

# Repositories and Mirrors

Termux packages, except bootstrap environment, are served via external web services. There is a primary package server (seed) and number or mirrors, which replicate the content from it to reduce load and provide a some level of redundancy. Mirrors are running either on behalf of maintainers, community members or unaffiliated third parties and are not guaranteed to be always available.

Packages require Termux running on Android 7.0 or higher. Do not try to use repositories listed there on legacy environments.

Service availability may vary depending on your device, Internet connection quality, and censorship events in your country. If we detect serious issue on our side, we will post announce on GitHub and our community pages. Other issues, like introduced on client side or somewhere between endpoints, would be ignored.

## How to use

Run `apt edit-sources`, comment out existing URLs and add line for picked repository, or use the `termux-change-repo` script that is part of the `termux-tools` package.

## Primary host

A default Termux packages repository and content seeder for available mirrors.

| Repository                                             | sources.list entry                                            |
|:-------------------------------------------------------|:--------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://packages.termux.dev/apt/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://packages.termux.dev/apt/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://packages.termux.dev/apt/termux-x11 x11 main`     |

CloudFlare CDN endpoint. Fast and stable, but has limits on uploads 100MB max per POST in "free" plan) which makes impossible to use it or submitting packages via GitHub Actions + Aptly REST API.

| Repository                                             | sources.list entry                                               |
|:-------------------------------------------------------|:-----------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://packages-cf.termux.dev/apt/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://packages-cf.termux.dev/apt/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://packages-cf.termux.dev/apt/termux-x11 x11 main`     |

Please don't use our host in termux forks. Set up your own repository. Otherwise consider to contribute to our project instead of maintaining the custom fork.

## Mirrors

There are listed all known Termux mirrors. If you hosted one but didn't find it in the list, please open the issue in https://github.com/termux/termux-tools/issues.

### Mirrors that are part of mirror rotation in pkg

These mirrors (listed alphabetically) might be picked, on random, when pkg checks available mirrors and picks one.

#### Mirrors by [a1batross](https://github.com/a1batross)

Updated four times per day.

| Repository                                             | sources.list entry                                         |
|:-------------------------------------------------------|:-----------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://termux.mentality.rip/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://termux.mentality.rip/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://termux.mentality.rip/termux-x11 x11 main`     |

#### Mirrors by the [Academic Computer Club in Umeå](https://www.accum.se/)

Updated every four hours.

| Repository                                             | sources.list entry                                         |
|:-------------------------------------------------------|:-----------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirror.accum.se/mirror/termux.dev/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirror.accum.se/mirror/termux.dev/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirror.accum.se/mirror/termux.dev/termux-x11 x11 main`     |

#### Mirrors by [AG DSN in Dresden](https://agdsn.de)

Updated daily.

| Repository                                             | sources.list entry                                         |
|:-------------------------------------------------------|:-----------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://ftp.agdsn.de/termux/termux-main stable main`  |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://ftp.agdsn.de/termux/termux-root root stable`  |
| [X11](https://github.com/termux/x11-packages)          | `deb https://ftp.agdsn.de/termux/termux-x11 x11 main`      |

#### Mirrors by [amocrenco](https://github.com/amocrenco)

Hosted in Chisinau, Moldova. Updated once per 6 hours. 10Gb/s and support IPV4/IPV6.

| Repository                                             | sources.list entry                                                    |
|:-------------------------------------------------------|:----------------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://md.mirrors.hacktegic.com/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://md.mirrors.hacktegic.com/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://md.mirrors.hacktegic.com/termux/termux-x11 x11 main`     |

#### Mirrors by [Jeonnam High School Software Solution Club](https://mirror.jeonnam.school)

Hosted in Gwangju, South Korea. Updated every one hour. 1Gb/s and support IPV4 only.

| Repository                                             | sources.list entry                                               |
|:-------------------------------------------------------|:-----------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirror.jeonnam.school/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirror.jeonnam.school/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirror.jeonnam.school/termux/termux-x11 x11 main`     |

#### Mirrors by [Bombyeol](https://github.com/Senarin)

Hosted in Daegu, South Korea. Updated every 4 hours. 1Gb/s and support IPV4/IPV6.

| Repository                                             | sources.list entry                                               |
|:-------------------------------------------------------|:-----------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirror.rinarin.dev/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirror.rinarin.dev/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirror.rinarin.dev/termux/termux-x11 x11 main`     |

#### Mirrors by [DomaiNesia](https://www.domainesia.com/) - Cloud Web Hosting Indonesia Terbaik

Hosted in Jakarta, Indonesia. Updated four times per day.

| Repository                                             | sources.list entry                                                             |
|:-------------------------------------------------------|:-------------------------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://linux.domainesia.com/applications/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://linux.domainesia.com/applications/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://linux.domainesia.com/applications/termux/termux-x11 x11 main`     |

#### Mirrors by [DiffieHellman](https://middlendian.com/)

Hosted in Australia. Updated daily.

| Repository                                             | sources.list entry                                                   |
|:-------------------------------------------------------|:---------------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirrors.middlendian.com/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirrors.middlendian.com/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirrors.middlendian.com/termux/termux-x11 x11 main`     |

#### Mirrors by [Grimler](https://github.com/grimler91)

Hosted in Helsinki, Finland. Mirrored from the main node, updated hourly.

| Repository                                             | sources.list entry                                      |
|:-------------------------------------------------------|:--------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://grimler.se/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://grimler.se/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://grimler.se/termux/termux-x11 x11 main`     |


#### Mirrors by [Librehat](https://github.com/librehat)

Updated four times per day.

| Repository                                             | sources.list entry                                            |
|:-------------------------------------------------------|:--------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://termux.librehat.com/apt/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://termux.librehat.com/apt/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://termux.librehat.com/apt/termux-x11 x11 main`     |

#### Mirrors by [mwt](https://github.com/mwt)

Hosted in East/West coast USA and Europe(via cdn). Updated four times per day.

Check which origin is serving you by checking:
https://mirror.mwt.me/mirror-heartbeat.txt

| Repository                                             | sources.list entry                                  |
|:-------------------------------------------------------|:----------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirror.mwt.me/termux/main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirror.mwt.me/termux/root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirror.mwt.me/termux/x11 x11 main`     |

#### Mirrors by [Nevacloud](https://nevacloud.com/) - Simplified Cloud Servers for Developers

Hosted in Jakarta, Indonesia. Updated four times per day.

| Repository                                             | sources.list entry                                                             |
|:-------------------------------------------------------|:-------------------------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirror.nevacloud.com/applications/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirror.nevacloud.com/applications/termux/root root stable`        |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirror.nevacloud.com/applications/termux/x11 x11 main`            |

#### Mirrors by [Purdue University Linux Users Group](https://plug-mirror.rcac.purdue.edu/info.html)

Hosted in Indiana, USA. Updated four times per day.

| Repository                                             | sources.list entry                                                       |
|:-------------------------------------------------------|:-------------------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://plug-mirror.rcac.purdue.edu/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://plug-mirror.rcac.purdue.edu/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://plug-mirror.rcac.purdue.edu/termux/termux-x11 x11 main`     |

#### Mirrors by [Computer Science Club of the University of Waterloo](https://csclub.uwaterloo.ca)

Hosted in Canada, Ontario, Waterloo. Updated twice times per day.

| Repository                                             | sources.list entry                                                       |
|:-------------------------------------------------------|:-------------------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirror.csclub.uwaterloo.ca/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirror.csclub.uwaterloo.ca/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirror.csclub.uwaterloo.ca/termux/termux-x11 x11 main`     |

#### Mirrors by [quantum5](https://github.com/quantum5)

Hosted in Toronto, Ontario, Canada. Updated four times per day.

| Repository                                             | sources.list entry                                                       |
|:-------------------------------------------------------|:-------------------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirror.quantum5.ca/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirror.quantum5.ca/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirror.quantum5.ca/termux/termux-x11 x11 main`     |

#### Mirrors by [Utermux](https://github.com/utermuxblog)

Hosted in Los Angeles, California, USA. Updated daily. 1Gb/s and support IPV4/IPV6.

More info at https://github.com/UtermuxBlog/Issue.

| Repository                                             | sources.list entry                                               |
|:-------------------------------------------------------|:-----------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirrors.utermux.dev/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirrors.utermux.dev/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirrors.utermux.dev/termux/termux-x11 x11 main`     |

#### Mirrors by [vern.cc](https://vern.cc)

Hosted in New York. Updated once per day.

| Repository                                             | sources.list entry                                          |
|:-------------------------------------------------------|:------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirror.vern.cc/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirror.vern.cc/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirror.vern.cc/termux/termux-x11 x11 main`     |

#### Mirrors by [Fremont Cabal Internet Exchange](https://fcix.net)

Hosted in Fremont, California, USA. Updated every 3 hours. 10Gbps and support IPV4/IPV6.

| Repository                                             | sources.list entry                                          |
|:-------------------------------------------------------|:------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirror.fcix.net/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirror.fcix.net/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirror.fcix.net/termux/termux-x11 x11 main`     |

#### Mirrors by [CyberRex0](https://github.com/cyberrex0)

Hosted in Japan. Updated every 6 hours.

| Repository                                             | sources.list entry                                               |
|:-------------------------------------------------------|:-----------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirrors.cbrx.io/apt/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirrors.cbrx.io/apt/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirrors.cbrx.io/apt/termux/termux-x11 x11 main`     |

#### Mirrors by [KuronekoServer](https://krnk.org/)

Hosted in Tokyo, Japan. Updated every 4 hours, 10Gbps and support IPv4. 

| Repository                                             | sources.list entry                                               |
|:-------------------------------------------------------|:-----------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirrors.krnk.org/apt/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirrors.krnk.org/apt/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirrors.krnk.org/apt/termux/termux-x11 x11 main`     |

#### Mirrors by [Exosunandnet](https://github.com/Exosunandnet)

Hosted in Spain. Updated every 6 hours. 1Gb/s and is IPv4 only.  

| Repository                                             | sources.list entry                                           |
|:-------------------------------------------------------|:-------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://termux.3san.dev/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://termux.3san.dev/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://termux.3san.dev/termux/termux-x11 x11 main`     |

#### Mirrors by [LumitoLuma](https://www.lumito.net)

Hosted in Germany, Updated every an hour.

| Repository                                             | sources.list entry                                               |
|:-------------------------------------------------------|:-----------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://cdn.lumito.net/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://cdn.lumito.net/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://cdn.lumito.net/termux/termux-x11 x11 main`     |

#### Mirrors by [FAU](https://www.fau.de)

Hosted in Erlangen, Germany. Updated every 6 hours. 25Gbps and support IPV4/IPV6.

More info at https://ftp.fau.de/about.html .

| Repository                                             | sources.list entry                                              |
|:-------------------------------------------------------|:----------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://ftp.fau.de/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://ftp.fau.de/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://ftp.fau.de/termux/termux-x11 x11 main`     |

#### Mirrors by [FlokiNET](https://flokinet.is)

This mirror is hosted in Reykjavík in Iceland, Bucharest in Romania and in the Netherlands. Updated once per day. 1Gbp/s and support IPV4/IPV6.

| Repository                                             | sources.list entry                                       |
|:-------------------------------------------------------|:---------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://is.mirror.flokinet.net/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://is.mirror.flokinet.net/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://is.mirror.flokinet.net/termux/termux-x11 x11 main`     |

| Repository                                             | sources.list entry                                       |
|:-------------------------------------------------------|:---------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://ro.mirror.flokinet.net/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://ro.mirror.flokinet.net/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://ro.mirror.flokinet.net/termux/termux-x11 x11 main`     |

| Repository                                             | sources.list entry                                       |
|:-------------------------------------------------------|:---------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://nl.mirror.flokinet.net/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://nl.mirror.flokinet.net/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://nl.mirror.flokinet.net/termux/termux-x11 x11 main`     |

#### Mirrors by [M3DZIK](https://github.com/M3DZIK)

Hosted in Frankfurt, Germany, Updated every 15 minutes. 4Gbp/s and is IPV4 only.

| Repository                                             | sources.list entry                                               |
|:-------------------------------------------------------|:-----------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirrors.medzik.dev/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirrors.medzik.dev/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirrors.medzik.dev/termux/termux-x11 x11 main`     |

#### Mirrors by [ICM, Warsaw University](https://icm.edu.pl/)

Hosted in Warsaw, Poland. Updated every 6 hours. 20Gbp/s and is IPV4/IPV6/RSYNC/FTP/GOPHER.

| Repository                                             | sources.list entry                                               |
|:-------------------------------------------------------|:-----------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://ftp.icm.edu.pl/pub/Linux/dist/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://ftp.icm.edu.pl/pub/Linux/dist/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://ftp.icm.edu.pl/pub/Linux/dist/termux/termux-x11 x11 main`     |

#### Mirrors by [Rodrigo de Avila](https://rda.run/)

Hosted in Brochier, Brazil. Updated once per day. 500MB/s and support IPV4/IPV6.

| Repository                                             | sources.list entry                                               |
|:-------------------------------------------------------|:-----------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirrors.rda.run/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirrors.rda.run/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirrors.rda.run/termux/termux-x11 x11 main`     |

#### Mirrors by [SunRed](https://sunred.org/)

Hosted in Falkenstein, Germany. Updated once per 2 hours, 1Gbp/s and support IPV4/IPV6.

| Repository                                             | sources.list entry                                               |
|:-------------------------------------------------------|:-----------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirror.sunred.org/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirror.sunred.org/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirror.sunred.org/termux/termux-x11 x11 main`     |

#### Mirrors by [Andriy Utkin](http://autkin.net/)

Hosted in Cambridge, UK. Updated nightly, 2MB/s and support IPV4/IPV6.

| Repository                                             | sources.list entry                                               |
|:-------------------------------------------------------|:-----------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirror.autkin.net/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirror.autkin.net/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirror.autkin.net/termux/termux-x11 x11 main`     |

#### Mirrors by [bouwhuis.network](https://bouwhuis.network/)

Hosted in Amsterdam, NL. Updated every 6 hours, 10Gbp/s and support IPV4/IPV6.

| Repository                                             | sources.list entry                                               |
|:-------------------------------------------------------|:-----------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirror.bouwhuis.network/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirror.bouwhuis.network/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirror.bouwhuis.network/termux/termux-x11 x11 main`     |

#### Mirrors by [Tomás Leite de Castro](https://leitecastro.com/)

Hosted in Lisbon, Portugal. Updated every one hour, 20Gbp/s and support IPV4/IPV6/RSYNC.

| Repository                                             | sources.list entry                                               |
|:-------------------------------------------------------|:-----------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirror.leitecastro.com/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirror.leitecastro.com/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirror.leitecastro.com/termux/termux-x11 x11 main`     |

#### Mirrors by [Nguyen Hoang](https://github.com/HoangTheBoss)

Hosted in Hanoi, Vietnam. Update Twice a day, 1Gbp/s and support IPV4 only.

| Repository                                             | sources.list entry                                               |
|:-------------------------------------------------------|:-----------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirrors.nguyenhoang.cloud/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirrors.nguyenhoang.cloud/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirrors.nguyenhoang.cloud/termux/termux-x11 x11 main`     |

#### Mirrors by [MeowIce](https://github.com/MeowIce)

Hosted in Ho Chi Minh, Vietnam. Update hourly, 500mbps ~ 1Gbp/s and support IPV4/IPV6 and HTTP/HTTPS/RSYNC. 

RSYNC link: `rsync://rsync.meowsmp.net/termux`  

| Repository                                             | sources.list entry                                               |
|:-------------------------------------------------------|:-----------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirror.meowsmp.net/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirror.meowsmp.net/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirror.meowsmp.net/termux/termux-x11 x11 main`     |

#### Mirrors by [karibu](mailto:karibu@freedif.com)

Hosted in Singapore. Updated every one hour, 10Gbp/s and support IPV4 only.

| Repository                                             | sources.list entry                                               |
|:-------------------------------------------------------|:-----------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirror.freedif.org/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirror.freedif.org/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirror.freedif.org/termux/termux-x11 x11 main`     |

#### Mirrors by [Taiwan Digital Streaming Co.](https://www.twds.com.tw/)

Hosted in Taiwan. Updated every 3 hours, 20 Gbps (80 Gbps for peers) and support IPV4/IPV6/RSYNC.

| Repository                                             | sources.list entry                                               |
|:-------------------------------------------------------|:-----------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirror.twds.com.tw/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirror.twds.com.tw/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirror.twds.com.tw/termux/termux-x11 x11 main`     |

#### Mirrors by [GNLUG](https://gnlug.org/)

Hosted in Ashburn, VA, United States. Updated every 6 hours, 1 Gbps and support IPV4/IPV6/RSYNC.

| Repository                                             | sources.list entry                                               |
|:-------------------------------------------------------|:-----------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://gnlug.org/pub/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://gnlug.org/pub/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://gnlug.org/pub/termux/termux-x11 x11 main`     |

### Mirrors hosted in India

Mirrors for users in India for better ping and download speed.

#### Mirrors by [Saswata](https://github.com/saswatasarkar13)

Hosted in India. Updated every one hour, 300Mbp/s and support IPV4 only.

| Repository                                             | sources.list entry                                               |
|:-------------------------------------------------------|:-----------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirrors.saswata.xyz/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirrors.saswata.xyz/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirrors.saswata.xyz/termux/termux-x11 x11 main`     |

#### Mirrors by [sahilister](https://github.com/sahilister)

Hosted in Mumbai, India. Updated every 6 hours, 1Gbp/s and support IPV4/IPV6.

| Repository                                             | sources.list entry                                               |
|:-------------------------------------------------------|:-----------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirrors.in.sahilister.net/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirrors.in.sahilister.net/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirrors.in.sahilister.net/termux/termux-x11 x11 main`     |

Hosted in Nuremberg, Germany. Updated every 6 hours, 1Gbp/s and support IPV4/IPV6.

| Repository                                             | sources.list entry                                               |
|:-------------------------------------------------------|:-----------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirrors.in.sahilister.net/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirrors.in.sahilister.net/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirrors.in.sahilister.net/termux/termux-x11 x11 main`     |

#### Mirrors by [Albonycal](https://github.com/Albonycal)

This mirror is hosted in India, Updated every 53 minutes.

| Repository                                             | sources.list entry                                       |
|:-------------------------------------------------------|:---------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirror.nag.albony.in/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirror.nag.albony.in/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirror.nag.albony.in/termux/termux-x11 x11 main`     |

#### Mirrors by [niranjan](https://niranjan.co/)

This mirror is hosted in Mumbai, India, updated every 30 minutes, 500Mbp/s and support IPV4/IPV6.

| Repository                                             | sources.list entry                                       |
|:-------------------------------------------------------|:---------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://termux.niranjan.co/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://termux.niranjan.co/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://termux.niranjan.co/termux-x11 x11 main`     |

#### Mirrors by [Ravi](https://ravidwivedi.in/)

This mirror is hosted in Mumbai, India, updated every 1 hour, 200MB/s and support IPV4/IPV6.

| Repository                                             | sources.list entry                                       |
|:-------------------------------------------------------|:---------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirrors.ravidwivedi.in/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirrors.ravidwivedi.in/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirrors.ravidwivedi.in/termux/termux-x11 x11 main`     |

## Mirrors hosted in Russia

Mirrors for users in Russia for better ping and download speed.

#### Mirrors by [National Research Nuclear University - Moscow Engineering Physics Institute](https://mephi.ru/)

| Repository                                             | sources.list entry                                  |
|:-------------------------------------------------------|:----------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb http://mirror.mephi.ru/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb http://mirror.mephi.ru/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb http://mirror.mephi.ru/termux/termux-x11 x11 main`     |

#### Mirrors by [dmitry](mailto:dmitry@shishkin.email)

Hosted in Nizhny Novgorod, Russia, updated four times per day.

| Repository                                             | sources.list entry                                  |
|:-------------------------------------------------------|:----------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://repository.su/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://repository.su/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://repository.su/termux/termux-x11 x11 main`     |

### Mirrors hosted in Chinese Mainland

Mirrors for users in Chinese Mainland for better ping and download speed.

#### Mirrors by [Beijing Foreign Studies University](http://www.bfsu.edu.cn/)

| Repository                                             | sources.list entry                                                   |
|:-------------------------------------------------------|:---------------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirrors.bfsu.edu.cn/termux/apt/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirrors.bfsu.edu.cn/termux/apt/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirrors.bfsu.edu.cn/termux/apt/termux-x11 x11 main`     |

#### Mirrors by [Chongqing University of Posts and Telecommunications](https://www.cqupt.edu.cn/)

More info at https://mirrors.cqupt.edu.cn/.

| Repository                                             | sources.list entry                                                    |
|:-------------------------------------------------------|:----------------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirrors.cqupt.edu.cn/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirrors.cqupt.edu.cn/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirrors.cqupt.edu.cn/termux/termux-x11 x11 main`     |

#### Mirrors by [Nanyang Institute of Technology](https://mirror.nyist.edu.cn/)

| Repository                                             | sources.list entry                                                   |
|:-------------------------------------------------------|:---------------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirror.nyist.edu.cn/termux/apt/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirror.nyist.edu.cn/termux/apt/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirror.nyist.edu.cn/termux/apt/termux-x11 x11 main`     |

#### Mirrors by [eScience Center, Nanjing University](https://www.nju.edu.cn/)

| Repository                                             | sources.list entry                                                 |
|:-------------------------------------------------------|:-------------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirror.nju.edu.cn/termux/apt/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirror.nju.edu.cn/termux/apt/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirror.nju.edu.cn/termux/apt/termux-x11 x11 main`     |

#### Mirrors by [Shandong University](https://mirrors.sdu.edu.cn/)

| Repository                                             | sources.list entry                                              |
|:-------------------------------------------------------|:----------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirrors.sdu.edu.cn/termux/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirrors.sdu.edu.cn/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirrors.sdu.edu.cn/termux/termux-x11 x11 main`     |

#### Mirrors by [Shenyang Aerospace University](https://mirrors.sau.edu.cn/)

| Repository                                             | sources.list entry                                                  |
|:-------------------------------------------------------|:--------------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirrors.sau.edu.cn/termux/apt/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirrors.sau.edu.cn/termux/apt/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirrors.sau.edu.cn/termux/apt/termux-x11 x11 main`     |

#### Mirrors by [Southern University of Science and Technology](https://mirrors.sustech.edu.cn/)

| Repository                                             | sources.list entry                                                      |
|:-------------------------------------------------------|:------------------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirrors.sustech.edu.cn/termux/apt/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirrors.sustech.edu.cn/termux/apt/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirrors.sustech.edu.cn/termux/apt/termux-x11 x11 main`     |

#### Mirrors by [Tsinghua University TUNA Association](https://tuna.moe/)

| Repository                                             | sources.list entry                                                            |
|:-------------------------------------------------------|:------------------------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirrors.tuna.tsinghua.edu.cn/termux/apt/termux-main stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirrors.tuna.tsinghua.edu.cn/termux/apt/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirrors.tuna.tsinghua.edu.cn/termux/apt/termux-x11 x11 main`     |

#### Mirrors by [Peking University](https://www.pku.edu.cn/)

| Repository                                             | sources.list entry                                                    |
|:-------------------------------------------------------|:----------------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirrors.pku.edu.cn/termux/termux-main/ stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirrors.pku.edu.cn/termux/termux-root/ root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirrors.pku.edu.cn/termux/termux-x11/ x11 main`     |

#### Mirrors by [University of Science and Technology of China, Linux User Group](https://lug.ustc.edu.cn/)

| Repository                                             | sources.list entry                                                    |
|:-------------------------------------------------------|:----------------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirrors.ustc.edu.cn/termux/termux-main/ stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirrors.ustc.edu.cn/termux/termux-root/ root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirrors.ustc.edu.cn/termux/termux-x11/ x11 main`     |

#### Mirrors by [Information Technology Center, Zhejiang University](https://zuits.zju.edu.cn/)

| Repository                                             | sources.list entry                                                    |
|:-------------------------------------------------------|:----------------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirrors.zju.edu.cn/termux/apt/termux-main/ stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirrors.zju.edu.cn/termux/apt/termux-root/ root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirrors.zju.edu.cn/termux/apt/termux-x11/ x11 main`     |

#### Mirrors by [Shanghai Jiao Tong University, *NIX User Group](https://sjtug.org/)

Hosted in Shanghai, China. Updated once per 2 hours, 1Gb/s with IPv4/IPv6 support.

| Repository                                             | sources.list entry                                                    |
|:-------------------------------------------------------|:----------------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirror.sjtu.edu.cn/termux/termux-main/ stable main` |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirror.sjtu.edu.cn/termux/termux-root/ root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirror.sjtu.edu.cn/termux/termux-x11/ x11 main`     |

#### Mirrors by [Alibaba Open Source Mirror Site](https://mirrors.aliyun.com/)

More info at https://mirrors.aliyun.com/about.

| Repository                                             | sources.list entry                                                          |
|:-------------------------------------------------------|:----------------------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirrors.aliyun.com/termux/termux-main stable main`      |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirrors.aliyun.com/termux/termux-root root stable` |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirrors.aliyun.com/termux/termux-x11 x11 main`               |

#### Mirrors by [ISCAS - Institute of Software, Chinese Academy of Sciences](https://isrc.iscas.ac.cn/)

| Repository                                             | sources.list entry                                                          |
|:-------------------------------------------------------|:----------------------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirror.iscas.ac.cn/termux/apt/termux-main/ stable main`        |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirror.iscas.ac.cn/termux/apt/termux-root/ root stable`        |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirror.iscas.ac.cn/termux/apt/termux-x11/ x11 main`            |

#### Mirrors by [Huazhong University of Science and Technology](mailto:mirror_support@hust.edu.cn)

Hosted in Wuhan, Hubei, China. Updated every 2 hours. 1Gbp/s and support IPV4 and IPV6.

| Repository                                             | sources.list entry                                                          |
|:-------------------------------------------------------|:----------------------------------------------------------------------------|
| [Main](https://github.com/termux/termux-packages)      | `deb https://mirrors.hust.edu.cn/termux/apt/termux-main/ stable main`        |
| [Root](https://github.com/termux/termux-root-packages) | `deb https://mirrors.hust.edu.cn/termux/apt/termux-root/ root stable`        |
| [X11](https://github.com/termux/x11-packages)          | `deb https://mirrors.hust.edu.cn/termux/apt/termux-x11/ x11 main`            |