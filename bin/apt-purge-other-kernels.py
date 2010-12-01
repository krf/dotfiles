#!/usr/bin/env python

import os, sys

def get_old_kernel_versions(runningKernel):
    oldKernelVersions = []
    for kernel in os.popen("ls /boot/vmlinuz*").readlines():
        kernel = kernel.replace("/boot/vmlinuz-", "").replace("-generic", "").strip()
        if kernel == runningKernel:
           continue # do not add running kernel

        if kernel:
            oldKernelVersions.append(kernel)
    return oldKernelVersions

def get_packages_from_kernel_versions(kernels):
    packages = []
    for kernel in kernels:
        # remove suffixes like "-generic-pae" from 2.6.35-23-generic-pae
        version = '-'.join(kernel.split('-')[:2])

        # build packages list
        cmd = "dpkg --get-selections *{0}*".format(version)
        for package in os.popen(cmd).readlines():
            package = package.split("\t")[0]
            packages.append(package)

    return packages

def get_running_kernel_version():
    return os.popen("uname -r").read().replace("-generic","").strip()

def main():
    runningKernel = get_running_kernel_version()
    print("Current kernel: {0}".format(runningKernel))

    oldKernelVersions = get_old_kernel_versions(runningKernel)
    if len(oldKernelVersions) > 0:
        packages = get_packages_from_kernel_versions(oldKernelVersions)
        if len(packages) > 0:
            cmd = ["sudo", "aptitude", "purge", "-P"]
            cmd += packages

            print("Executing '{0}'".format(" ".join(cmd)))
            os.execvp(cmd[0], cmd[0:])
        else:
            print("Old kernels found but no packages matched. Exit.")
            sys.exit(1)
    else:
        print("No old kernels found. Exit.")
        sys.exit(0)

if __name__ == "__main__":
    main()
