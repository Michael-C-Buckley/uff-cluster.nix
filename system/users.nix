{inputs, ...}: let
  allGroups = [ "networkmanager" "wheel" "wireshark" ];

  mkUser = _: {isNormalUser = true; extraGroups = allGroups;};
in {
  imports = [
    inputs.nix-secrets.nixosModules.users
  ];
  users.users = {
    michael = mkUser {};
    shawn = mkUser {};
  };
}
