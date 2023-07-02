{
  description = "moody's linux systems";

  inputs = {
    nixpkgs.url = "github:majiru/nixpkgs/nixos-23.05";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs,  ... }@attrs: {
    nixosConfigurations."sakuya" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ./configuration.nix
      ];
    };
  };
}
