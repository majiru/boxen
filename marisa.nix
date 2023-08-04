# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ pkgs, inputs, ... }:

{

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "marisa";
  networking.wireless.enable = true;

  hardware.opengl.enable = true;
  users.users.moody = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" ];
  };

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
    pipewire
    git
    hexchat
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
    qemu_kvm
    ffmpeg
    vlc
    man-pages
    man-pages-posix
    pc
    hunspell
    hunspellDicts.en_US
    plan9port
    ed
    file
    nixpkgs-review
    unzip

    # YUCK!
    discord
  ];


  networking.firewall.enable = false;
  networking.wireless.userControlled.enable = true;
  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
