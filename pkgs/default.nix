# Default System Packages
{pkgs, ...}: {
  imports = [
    ./network.nix
  ];

  environment.systemPackages = with pkgs; [
    # System
    fastfetch
    microfetch
    killall

    # Shells (Zsh defined on its own)
    nushell
    tmux

    # Editor
    neovim
    python3
    git
    tig

    # File/Navigation
    lsd
    fd
    du-dust
    fzf
    zoxide
    bat
    ripgrep
    wget
    zip
    zsh
    fish

    # Performance
    atop
    btop
    htop

    # Hardware
    usbutils
    pciutils
    smartmontools
    lm_sensors
  ];
}
