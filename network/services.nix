_: {
  services = {
    ntpd-rs.enable = true;
    frr = {
      bgpd.enable = true;
      ospfd.enable = true;
    };
  };
}
