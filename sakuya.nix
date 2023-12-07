{ config, pkgs, ... }:
{

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.kernel.sysctl = {
    "net.ipv4.tcp_congestion_control" = "reno";
  };

  # Don't let ethernet card DHCP
  networking.useDHCP = false;
  networking.hostName = "sakuya";
  networking.hostId = "d028bb22";
  networking.extraHosts = ''
    192.168.168.209 flan
  '';
  systemd.network = {
    enable = true;
    netdevs = {
      "20-br0".netdevConfig = {
        Kind = "bridge";
        Name = "br0";
        MACAddress = "de:ad:be:ef:42:13";
      };
      "20-tap0".netdevConfig = {
        Kind = "tap";
        Name = "tap0";
      };
    };
    networks = {
      "30-enp7s0" = {
        matchConfig.Name = "enp7s0";
        networkConfig.Bridge = "br0";
        linkConfig.RequiredForOnline = "enslaved";
      };
      "30-tap0" = {
        matchConfig.Name = "tap0";
        networkConfig.Bridge = "br0";
        linkConfig.RequiredForOnline = "enslaved";
      };
      "40-br0" = {
        matchConfig.Name = "br0";
        networkConfig.DHCP = "ipv4";
        bridgeConfig = { };
        linkConfig.RequiredForOnline = "carrier";
      };
    };
  };

  systemd.services."systemd-networkd-wait-online".serviceConfig.ExecStart = [
    ""
    "${config.systemd.package}/lib/systemd/systemd-networkd-wait-online --any"
  ];

  security.pam.dp9ik = {
    enable = true;
    authserver = "flan";
  };

  system.fsPackages = [ pkgs._9ptls ];
  boot.supportedFilesystems = [ "zfs" ];
  fileSystems = {
    "/media" = {
      device = "/dev/disk/by-uuid/9dd50c72-23a0-42dd-9648-b41e938ad98c";
      options = [ "nofail" ];
    };
  };

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
    zfs
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
    games.pokecrystal
    games.pokered
    games.shipwright
    games.pokeemerald
    games.zelda3
    games.pokefirered
    games.pokeyellow
    games.pokegold
    pc
    hunspell
    hunspellDicts.en_US
    plan9port
    ed
    file
    nixpkgs-review
    unzrip
    dolphin-emu
    citra-nightly
    pinentry-curses
    chromium
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [ obs-pipewire-audio-capture ];
    })

    # YUCK!
    discord

    (writeScriptBin "mutemic"
      ''
        #!/usr/bin/env bash
        # wpctl is the pactl we have at home
        mic="alsa_input.usb-0c76_USB_PnP_Audio_Device-00.mono-fallback"
        id="$(pw-dump -N | jq '.[] | select(.info.props."node.name"=="'$mic'")| .id')"
        if test "$#" -gt 0; then
          wpctl set-mute $id $*
        else
          wpctl set-mute $id toggle
        fi
      ''
    )
    (writeScriptBin "auxtoggle"
      ''
        #!/usr/bin/env bash
        # everything uses id's except pw-metadata because no one thought this out
        speakers="alsa_output.pci-0000_0c_00.4.analog-stereo"
        cans="alsa_output.usb-JDS_Labs_JDS_Labs_Atom_DAC-00.analog-stereo"
        if pw-metadata 0 default.audio.sink | grep -q $cans; then
          pw-metadata 0 default.audio.sink '{"name":"'$speakers'"}'
        else
          pw-metadata 0 default.audio.sink '{"name":"'$cans'"}'
        fi
      ''
    )
  ];

  services.udev.packages = [ pkgs.dolphin-emu ];
  services.jellyfin.enable = true;
  programs.steam.enable = true;
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
  };
  services.avahi.enable = true;
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

