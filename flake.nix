{
  description = "moody's linux systems";

  inputs = {
    nixpkgs.url = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    jovian.url = "github:jovian-Experiments/Jovian-NixOS";
    jovian.inputs.nixpkgs.follows = "nixpkgs";

    gameover.url = "github:majiru/gameover";
    gameover.inputs.nixpkgs.follows = "nixpkgs";

    kde2nix.url = "github:nix-community/kde2nix";
    kde2nix.inputs.nixpkgs.follows = "nixpkgs";

    vacme-vim = {
      url = "github:olivertaylor/vacme";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, jovian, kde2nix, ... }@inputs: {
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
      "nitori" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./nitori-hardware.nix
          ./prefs.nix
          ./nix.nix
          jovian.outputs.nixosModules.jovian
          kde2nix.outputs.nixosModules.default
          ./nitori.nix
          ./home.nix
        ];
      };
    };
  };
}
