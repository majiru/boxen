{ pkgs, inputs, ... }:
{
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.trusted-users = [ "root" "@wheel" ];
    registry."N".flake = inputs.nixpkgs;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  };

  nixpkgs.overlays = [
    (self: super: {
      vimPlugins = super.vimPlugins // {
        vacme-vim = pkgs.vimUtils.buildVimPluginFrom2Nix {
          name = "vacme-vim";
          src = inputs.vacme-vim;
        };
      };
    })
    inputs.gameover.overlays.default
  ];
}
