{ config, inputs, pkgs, ... }: {
  boot.kernelPackages = inputs.jovian.outputs.legacyPackages.x86_64-linux.linuxPackages_jovian;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl = {
    "net.ipv4.tcp_congestion_control" = "reno";
  };

  nixpkgs.overlays = [
    (final: prev: {
      makeModulesClosure = x:
        prev.makeModulesClosure (x // { allowMissing = true; });
    })
  ];
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    curl
    wayland
    grim
    slurp
    wl-clipboard
    mako
    xdg-utils
    bemenu
    wdisplays
    wget
    firefox
    sway
    telegram-desktop
    pavucontrol
    passage
    gnumake
    gcc
    git
    thunderbird
    gnome3.adwaita-icon-theme
    nawk
    xfce.thunar
    transmission-gtk
    mpv
    jq
    htop
    wlclock
    rc-9front
    drawterm-wayland
    tlsclient
    libnotify
    go
    gopls
    nil
    nixpkgs-fmt
    imv
    ffmpeg
    man-pages
    man-pages-posix
    games.pokecrystal
    games.pokered
    games.pokeemerald
    games.pokefirered
    games.pokeyellow
    games.pokegold
    games.zelda3
    games.shipwright
    pc
    ed
    file
    unzrip
    dolphin-emu
    citra-nightly
    mgba
  ];

  jovian.devices.steamdeck.enable = true;
  jovian.steam.autoStart = true;
  services.xserver.desktopManager.plasma5.enable = true;
  networking.networkmanager.enable = true;
  jovian.steam.desktopSession = "plasmawayland";
  jovian.steam.user = "moody";
  jovian.steam.enable = true;
  programs.steam.enable = true;

  hardware.opengl.enable = true;
  security.sudo.wheelNeedsPassword = false;

  networking.hostName = "nitori";
  users.users.moody = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" ];
  };

  services.udev.packages = [ pkgs.dolphin-emu ];
  services.openssh.enable = true;
  system.stateVersion = "24.05";
}
