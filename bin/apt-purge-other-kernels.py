#!/usr/bin/env python

import os, sys

def get_kernel_packages():
    packages = []

    # build packages list, get all kernel packages
    cmd = "dpkg --get-selections \"linux-*-*.*.*\""
    for line in os.popen(cmd).readlines():
        package = line.split("\t")[0]
        packages.append(package)

    return packages

def get_running_kernel_version():
    return os.popen("uname -r").read().replace("-generic","").strip()

def main():
    running_kernel_version = get_running_kernel_version()
    print("Current kernel: {0}".format(running_kernel_version))

    packages = get_kernel_packages()

    # filter out current kernel
    packages = [pkg for pkg in packages if not running_kernel_version in pkg]

    if len(packages) > 0:
        cmd = ["sudo", "apt-get", "purge"]
        cmd += packages

        print("Executing '{0}'".format(" ".join(cmd)))
        os.execvp(cmd[0], cmd[0:])
    else:
        print("No old kernels found. Exit.")
        sys.exit(0)

if __name__ == "__main__":
    main()
