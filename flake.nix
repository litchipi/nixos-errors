{
  description = "NixOS error";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/3a70dd92993182f8e514700ccf5b1ae9fc8a3b8d"; #nixos-23.05";
    nixosgen = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ...}@inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in rec {
    defaultPackage.${system} = vm;
    vm  = inputs.nixosgen.nixosGenerate {
      inherit pkgs;
      format = "vm-nogui";
      modules = [ ./machine.nix ];
    };

    virtualbox_hardened = pkgs.virtualbox;
    virtualbox_not_hardened = pkgs.virtualbox.overrideAttrs (old: {
      enableHardening = false;
    });
    kernelmod_vboxdrv_hardened = pkgs.linuxKernel.packages.linux_zen.virtualbox;
  };
}
