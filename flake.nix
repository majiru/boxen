{
  description = "moody's linux systems";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@attrs:
    let
      system = "x86_64-linux";
      overlay-unstable = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${prev.system};
      };
    in {
      nixosConfigurations."sakuya" = nixpkgs.lib.nixosSystem {
        inherit system;
	specialArgs = attrs;
	modules = [
          ({config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
	  ./configuration.nix
	];
      };
    };
}
