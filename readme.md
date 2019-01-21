# Wireless Panda

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/65ca3c47e17f46a2b25fd6a9377fb189)](https://www.codacy.com/app/jocic/Linux.WirelessPanda?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=jocic/Linux.WirelessPanda&amp;utm_campaign=Badge_Grade)

Wireless Panda is a Linux distribution built from scratch for security audit of Wireless Networks using latest and greatest tools available. Now you're probably thinking to yourself: "Why?" Why, indeed? Why not?

**Note:** This Linux distribution was built by using the LFS guide which can be found by clicking [here](https://www.tldp.org/LDP/lfs/LFS-BOOK-6.1.1-NOCHUNKS.html).

**Song of the project:** [Sabaton - The Art of War](https://www.youtube.com/watch?v=aYoK1N90KDk)

**Project is still under development...slow ride...take it easy...**

## Requirements

It's recommended that you build Panda using a Debian-based distribution with following packages installed:

*   attr
*   gawk
*   gcc
*   gcc-multilib
*   g++
*   g++-multilib
*   libattr1
*   libattr1-dev
*   m4

Install them by executing the command below.

```bash
sudo apt-get install attr gawk gcc gcc-multilib g++ g++-multilib libattr1 libattr1-dev m4
```

## Core Packages

Preparing core packages is quite a long process which will download and compile all of the packages listed in the table below. Compilation time of each package is represented by the Standard Build Unit (SBU) which is calculated when you first run the script and compile **acl** used as a reference.

<table>
    <tr>
        <td colspan="6">
            <strong>Core Packages</strong>
        </td>
    </tr>
    <tr>
        <td>
            <a href="https://download.savannah.gnu.org/releases/acl/acl-2.2.53.tar.gz" title="Version 2.2.53" target="_blank">
                Acl
            </a>
        </td>
        <td>
            <a href="https://download.savannah.gnu.org/releases/attr/attr-2.4.48.tar.gz" title="Version 2.4.48" target="_blank">
                Attr
            </a>
        </td>
        <td>Autoconf</td>
        <td>Automake</td>
        <td>Bash</td>
        <td>Bc</td>
    </tr>
    <tr>
        <td>Binutils</td>
        <td>Bison</td>
        <td>Bzip2</td>
        <td>Check</td>
        <td>Coreutils</td>
        <td>DejaGNU</td>
    </tr>
    <tr>
        <td>Diffutils</td>
        <td>E2fsprogs</td>
        <td>Eudev</td>
        <td>Expat</td>
        <td>Expect</td>
        <td>File</td>
    <tr>
        <td>Findutils</td>
        <td>Flex</td>
        <td>Gawk</td>
        <td>Gcc</td>
        <td>GDBM</td>
        <td>Gettext</td>
    <tr>
        <td>Glibc</td>
        <td>GMP</td>
        <td>Gperf</td>
        <td>Grep</td>
        <td>Groff</td>
        <td>GRUB</td>
    <tr>
        <td>Gzip</td>
        <td>Iana-Etc</td>
        <td>Inetutils</td>
        <td>Initltool</td>
        <td>IPRoute2</td>
        <td>Kbd</td>
    <tr>
        <td>Kmod</td>
        <td>Less</td>
        <td>Libcap</td>
        <td>Libelf</td>
        <td>Libffi</td>
        <td>Libpipeline</td>
    <tr>
        <td>Libtool</td>
        <td>M4</td>
        <td>Make</td>
        <td>Man-DB</td>
        <td>Man-Pages</td>
        <td>Meson</td>
    <tr>
        <td>MPC</td>
        <td>MPFR</td>
        <td>Ncurses</td>
        <td>Ninja</td>
        <td>Openssl</td>
        <td>Patch</td>
    <tr>
        <td>Perl</td>
        <td>Pkg-config</td>
        <td>Popt</td>
        <td>Procps-ng</td>
        <td>Psmisc</td>
        <td>Python</td>
    <tr>
        <td>Readline</td>
        <td>Sed</td>
        <td>Shadow</td>
        <td>Syskdlog</td>
        <td>Systemd</td>
        <td>Sysvinit</td>
    <tr>
        <td>Tar</td>
        <td>Tcl</td>
        <td>Texinfo</td>
        <td>Util-linux</td>
        <td>Vim</td>
        <td>XML::Parser</td>
    <tr>
        <td>Xz</td>
        <td>Zlib</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
    </tr>
</table>

In addition to that, Linux Kernel 5.0-RC2 will be downloaded and compiled.

## Pentesting Packages

...

## Tasks

*   Add an integrity check for downloaded archives
*   Refactor existing scripts
*   Integrate Openbox to the project

## Support

Please don't hesitate to contact me if you have any questions, ideas, or concerns.

My Twitter account is: [@jocic_91](https://www.twitter.com/jocic_91)

My support E-Mail address is: [support@djordjejocic.com](mailto:support@djordjejocic.com)

## Copyright & License

Copyright (C) 2019 Đorđe Jocić

Licensed under the GNU AGPL license.
