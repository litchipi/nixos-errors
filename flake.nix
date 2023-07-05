{
  description = "NixOS error";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixosgen = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ...}@inputs: let
    system = "x86_64-linux";
  in rec {
    defaultPackage.${system} = vm;
    vm  = inputs.nixosgen.nixosGenerate {
      pkgs = import nixpkgs { inherit system; };
      format = "vm-nogui";
      modules = [ ./machine.nix ];
    };
  };
}
