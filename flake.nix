{
  description = "My NixOS Server Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # Utilities
    nix-secrets.url = "git+ssh://git@github.com/Michael-C-Buckley/nix-secrets";

    michael-home = {
      url = "github:Michael-C-Buckley/home-config";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "";
    };

    hjem.follows = "michael-home/hjem";

    nix-devshells = {
      url = "github:Michael-C-Buckley/nix-devshells";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-modules = {
      url = "github:Michael-C-Buckley/nixos-modules";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-devshells.follows = "nix-devshells";
    };

    ragenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nix-devshells, ... } @ inputs:
  let
    systemConfig = { host, extraModules ? [] }: nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./base.nix
        ./hosts/${host}
      ] ++ extraModules;
    };

    uffList = [
      "uff1"
      "uff2"
      "uff3"
    ];

    uffConfigs = builtins.listToAttrs (map (host: {
      name = host;
      value = systemConfig { inherit host; extraModules = []; };
    }) uffList);
  in
  {
    nixosConfigurations = uffConfigs;

    checks = nix-devshells.checks;
    devShells.x86_64-linux.default = with nixpkgs.legacyPackages.x86_64-linux; mkShell {
      inherit (nix-devshells.devShells.x86_64-linux.nixosServers) buildInputs;
      shellHook = let 
        base = "ansible-playbook -i tools/ansible/inventory.ini tools/ansible/rebuild";
      in ''
        ${nix-devshells.devShells.x86_64-linux.nixos.shellHook or ""}
        # Shorthand for dry run
        dr() {
          nixos-rebuild dry-run --flake .#"$@"
        }
        # Ansible Shortcut Aliases
        alias rbb='${base}-boot.yml'
        alias rbs='${base}-switch.yml'
        alias rbt='${base}-test.yml'
	      alias rbrb='${base}-reboot.yml'
      '';
    };
  };
}
