{
  description = "moody's linux systems";

  inputs = {
    nixpkgs.url = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    gameover.url = "sourcehut:~moody/gameover";
    gameover.inputs.nixpkgs.follows = "nixpkgs";

    vacme-vim = {
      url = "github:olivertaylor/vacme";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      "sakuya" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./sakuya-hardware.nix
          ./prefs.nix
          ./nix.nix
          ./sakuya.nix
          ./home.nix
        ];
      };
      "marisa" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./marisa-hardware.nix
          ./nix.nix
          ./prefs.nix
          ./marisa.nix
          ./home.nix
        ];
      };
    };
  };
}
