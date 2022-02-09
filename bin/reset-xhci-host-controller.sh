#!/bin/sh

# as per https://www.reddit.com/r/System76/comments/j0b901/oryx_pro_oryp4_xhic_host_controller/

sudo echo -n "0000:00:14.0" > /sys/bus/pci/drivers/xhci_hcd/unbind
# sleep 3 # needed?
sudo echo -n "0000:00:14.0" > /sys/bus/pci/drivers/xhci_hcd/bind
