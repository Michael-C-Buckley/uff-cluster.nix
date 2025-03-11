{config, pkgs, ...}: let
  # This passes if my custom nvidia module is used, since I use power management by default
  nvda = config.hardware.nvidia.powerManagement.enable;
  nvidiaPackages = with pkgs; lib.optionals nvda [
    cudaPackages.cudatoolkit
    linuxPackages.nvidia_x11
    nvidia-container-toolkit
    libnvidia-container
  ];
in {
  environment.systemPackages = with pkgs; [
    cfssl
    openssl
    kubernetes
    kubernetes-helm
    kubectl
    kompose
    # calicoctl
    # calico-apiserver
    # calico-cni-plugin
    # calico-kube-controllers
    # calico-app-policy
  ] ++ nvidiaPackages;
}
