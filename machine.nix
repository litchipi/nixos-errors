{ config, lib, pkgs, ...}:
{
  system.stateVersion = "23.05";
  
  users.users."joe" = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    password = "joe";
  };
  
  networking.hostName = "joevm";

  users.mutableUsers = false;
  
  environment.systemPackages = [
  ];

  virtualisation = {
    cores = 2;
    memorySize = 2048;
    diskSize = 1024*4;
  };
}
