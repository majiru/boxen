{
  description = "moody's linux systems";

  inputs = {
    nixpkgs.url = "github:majiru/nixpkgs/nixos-23.05";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    gameover.url = "sourcehut:~moody/gameover";
    gameover.inputs.nixpkgs.follows = "nixpkgs";

    vacme-vim = {
      url = "github:olivertaylor/vacme";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations."sakuya" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
      ];
    };
  };
}
