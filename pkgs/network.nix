{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Hardware
    ethtool
    tcpdump
    iperf
    nftables
    inetutils
    bridge-utils
    openvswitch

    # IP/Routing
    frr
    iproute2
    dig
    ndisc6

    # Security
    wireguard-tools
    nmap

    # L2
    vlan
    lldpd
    cdpr
  ];
}
