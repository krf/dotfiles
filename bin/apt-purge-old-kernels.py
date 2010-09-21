#!/usr/bin/env python

import os, sys

def get_old_kernel_versions(runningKernel):
    oldKernels = []
    for kernel in os.popen("ls /boot/vmlinuz*").readlines():
        kernel = kernel.replace("/boot/vmlinuz-", "").replace("-generic", "").strip()
        if kernel == runningKernel:
            continue # do not add running kernel

        if kernel:
            oldKernels.append(kernel)
    return oldKernels

def get_packages_from_kernel_versions(kernels):
    packages = []
    for kernel in kernels:
        cmd = "dpkg --get-selections *{0}*".format(kernel)
        for package in os.popen(cmd).readlines():
            package = package.split("\t")[0]
            packages.append(package)

    return packages
    
def get_running_kernel_version():
    return os.popen("uname -r").read().replace("-generic","").strip()

def main():
    runningKernel = get_running_kernel_version()
    print("Current kernel: {0}".format(runningKernel))

    if len(get_old_kernel_versions(runningKernel)) > 0:
        if len(get_packages_from_kernel_versions(oldKernels)) > 0:
            cmd = "sudo aptitude purge -P {1}".format(" ".join(packages))
            
            print("Executing '{0}'".format(cmd))
            os.popen(cmd)
            sys.exit(0)
        else:
            print("Old kernels but no packages found. Exit.")
            sys.exit(1)
    else:
        print("No old kernels found. Exit.")
        sys.exit(0)

if __name__ == "__main__":
    main()
