{ config, lib, pkgs, ...}: let
  # Recreate the config from https://github.com/NixOS/nixpkgs/blob/nixos-23.05/nixos/modules/virtualisation/virtualbox-host.nix
  package = pkgs.virtualbox;
  virtualbox = package.override {
    enableHardening = true;
    headless = true;
    enableWebService = false;  # FIXME Bug there:   wsimport not found
  };

  kernelModules = config.boot.kernelPackages.virtualbox.override {
    inherit virtualbox;
  };

  vbox_config = {
    boot.kernelModules = [ "vboxdrv" "vboxnetadp" "vboxnetflt" ];
    boot.extraModulePackages = [ kernelModules ];
    environment.systemPackages = [ virtualbox ];
  };
in {
  system.stateVersion = "23.05";
  
  users.users."joe" = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    password = "joe";
  };
  
  networking.hostName = "joevm";
  services.openssh.enable = true;

  users.mutableUsers = false;
  
  virtualisation = {
    cores = 2;
    memorySize = 2048;
    diskSize = 1024*4;

    forwardPorts = [
      { from = "host"; host.port = 2222; guest.port = 22; }
    ];
  };

  environment.systemPackages = [
  ];

  users.extraGroups.vboxusers.members = [ "joe" ];
  virtualisation.virtualbox.host = {
    enable = true;
    headless = true;
    enableHardening = true;
    enableWebService = false; #true;  # FIXME   Bug there
  };

  # To test:
  #  - Without hardening   ->   fail wsimport
  #  - Build the package "virtualbox" WITH hardening -> OK
  #  - Build the package "virtualbox" WITHOUT hardening -> OK
  #  - Build only the kernel modules:
  #    [ "vboxdrv" "vboxnetadp" "vboxnetflt" ]
# } // vbox_config
}
