{config, ...}: let
  brIP = config.custom.uff.bridgeIPv4;
  enusb1 = config.custom.uff.enusb1;
  loopback = config.custom.uff.loopbackIPv4;
in {
  services.frr = {
    bgpd.enable = true;
    ospfd.enable = true;
  };

  systemd.network = {
    links."10-enusb1" = {
      matchConfig.MACAddress = config.custom.uff.enusb1.macAddr;
      linkConfig = {
        Name = "enusb1";
        MTUBytes = 9000;
      };
    };

    networks = {
      br0.bridgeConfig = {
        type = "bridge";
        name = "br0";
      };
    };
  };

  networking = {
    # Add the first interface into a bridge and a default route
    bridges.br0.interfaces = ["eno1"];

    interfaces = {
      # L3 reachable loopback addresses for host and anycast
      lo.ipv4.addresses = [
        {address=loopback; prefixLength=32;}
        {address="192.168.61.0"; prefixLength=32;}
      ];
      # This is the 2.5G USB NIC
      enusb1.ipv4.addresses = [
        {address = enusb1.ipv4.addr; prefixLength = enusb1.ipv4.prefixLength;}
      ];
      br0.ipv4 = {
        addresses = [
          {address = brIP; prefixLength = 24;}
        ];
        routes = [
          {address = "0.0.0.0"; prefixLength = 0; via = "192.168.48.1";}
        ];
      };
    };
  };
}
