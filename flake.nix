{
  description = "moody's linux systems";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable }:
    let
      system = "x86_64-linux";
      overlay-unstable = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${prev.system};
      };
    in {
      nixosConfiguration."sakuya" = nixpkgs.lib.nixosSystem {
        inherit system;
	modules = [
          ({config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
	  ./configuration.nix
	];
      };
    };
}
