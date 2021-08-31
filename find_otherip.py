#!/usr/bin/env python3
import sys
from scapy.all import *

if len(sys.argv) < 2:
    print("# No interface specified")
    sys.exit(1)
ifname=sys.argv[1]
mymacaddr = get_if_hwaddr(ifname)
print("# Capturing on {} (macaddr={}".format(ifname, get_if_hwaddr(ifname)))



def arp_monitor_callback(pkt):
    if ARP in pkt and pkt[ARP].op in (1,2):
        this_macaddr = pkt.sprintf("%ARP.hwsrc%")
        if this_macaddr == mymacaddr:
            return
        return pkt.sprintf("%ARP.hwsrc% is-at %ARP.psrc%")

sniff(iface=ifname, prn=arp_monitor_callback, filter="arp", store=0)
