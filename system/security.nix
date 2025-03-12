{config, pkgs, inputs, ...}: {

  imports =  [
    inputs.ragenix.nixosModules.default
  ];

  environment.systemPackages = with pkgs;  [
    ragenix
    sops
  ];

  security = {
    sudo = {
      execWheelOnly = true;
      wheelNeedsPassword = false;
      extraConfig = "Defaults lecture=never";
    };
  };

  services = {
    printing.enable = false;
    openssh.enable = true;

    fail2ban = {
      enable = config.networking.firewall.enable;
      maxretry =  4;
      bantime = "30m";
    };
  };

  networking = {
    nftables = {
      enable = true;
    };
    firewall = {
      extraInputRules = ''
        ip protocol 89 accept comment "Allow OSPF"
      '';
      enable = false;
      allowPing =  true;
      allowedTCPPorts = [22 179 5201];
      allowedUDPPorts = [53 5201];
    };
  };
}
