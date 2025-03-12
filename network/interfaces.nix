{config, ...}: let
  brIP = config.custom.uff.bridgeIPv4;
  enusb1 = config.custom.uff.enusb1;
  loopback = config.custom.uff.loopbackIPv4;

  addr = addr: prefix: {
    address = addr;
    prefixLength = prefix;
  };
in {
  networking = {
    networkmanager.unmanaged = ["wlp2s0"];
    wireless = {
      enable = true;
      # Network info here
    };
    # Add the first interface into a bridge and a default route
    bridges.br0.interfaces = ["eno1"];

    interfaces = {
      # Wifi gets DHCP
      wlp2s0.useDHCP = true;
      # Disable DHCP for the onboard ethernet
      eno1.useDHCP = false;
      # L3 reachable loopback addresses for host and anycast
      lo.ipv4.addresses = [
        (addr loopback 32)
        (addr "192.168.61.0" 32)
      ];
      # This is the 2.5G USB NIC
      enusb1.ipv4.addresses = [
        (addr enusb1.ipv4.addr enusb1.ipv4.prefixLength)
      ];
      br0.ipv4.addresses = [
        (addr brIP 24)
      ];
    };
  };
}
