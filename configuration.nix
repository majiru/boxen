{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "sakuya";
  networking.hostId = "d028bb22";

  boot.supportedFilesystems = [ "zfs" ];
  fileSystems = {
    "/media" = {
      device = "/dev/disk/by-uuid/9dd50c72-23a0-42dd-9648-b41e938ad98c";
      options = [ "nofail" ];
    };
  };

  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  fonts.fonts = with pkgs; [
    uni-vga
    dejavu_fonts
    freefont_ttf
    gyre-fonts # TrueType substitutes for standard PostScript fonts
    liberation_ttf
    unifont
    noto-fonts-emoji
    unifont
    noto-fonts
  ];

  hardware.opengl.enable = true;
  security.polkit.enable = true;
  users.users.moody = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" ];
  };

  home-manager.useUserPackages = true;
  environment.pathsToLink = [ "/share/bash-completion" ];
  home-manager.users.moody = {pkgs, fonts, ... }: {
    home.packages = [];
    home.stateVersion = "23.05";
    home.sessionVariables = {
      EDITOR = "nvim";
    };
    home.shellAliases = {
      "dn" = "makoctl dismiss -a";
      "grimslurp" = ''grim -g "$(slurp)"'';
    };

    programs = {
      bash = {
        enable = true;
        bashrcExtra = ''
          export PS1="; "
        '';
      };
      neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
      };
      foot = {
        enable = true;
        settings = {
          main = {
            term="xterm-256color";
            font = "VGA:size=12";
            font-bold = "VGA:size=12";
            font-italic = "VGA:size=12";
          };
          cursor.color="45363b 45363b";
          colors = {
            background = "FFFFFF";
            foreground = "45363b";
            
            regular0 = "20111a";
            regular1 = "bd100d";
            regular2 = "858062";
            regular3 = "e9a448";
            regular4 = "416978";
            regular5 = "96522b";
            regular6 = "98999c";
            regular7 = "958b83";
            
            bright0 = "5e5252";
            bright1 = "bd100d";
            bright2 = "858062";
            bright3 = "e9a448";
            bright4 = "416978";
            bright5 = "96522b";
            bright6 = "98999c";
            bright7 = "d4ccb9";
          };
        };
      };
    };

    wayland.windowManager.sway = {
      enable = true;
      #unforunately we can not use these flags with homemanger
      extraConfig = ''
        bindsym --no-repeat Mod4+z exec "mutemic 0"
        bindsym --release Mod4+z exec "mutemic 1"
        bindsym Mod4+Shift+z exec "auxtoggle"
      '';
      config = rec {
        modifier = "Mod4";
        terminal = "foot";
        bars = [];
        startup = [
          { command = "wlclock --position top-right --output DP-1"; }
        ];
        colors = {
          focused = {
            background = "#000000";
            border = "#55aaaa";
            text = "#000000";
            childBorder = "#55aaaa";
            indicator = "#000000";
          };
          unfocused = {
            background = "#b2b2b2";
            border = "#9eeeee";
            text = "#000000";
            childBorder = "#9eeeee";
            indicator = "#000000";
          };
        };
        window.commands = [
          {
            command = "border pixel 4";
            criteria = {
              title = "[.]*";
              app_id = "[.]*";
              class = "[.]*";
            };
          }
        ];
        # tiling is for nerds
        floating.criteria = [
          { title = "[.]*";  }
          { app_id = "[.]*";  }
          { class = "[.]*";  }
        ];
        output = {
          DP-1 = {
            bg = "#b2b2b2 solid_color";
            mode = "1920x1080@60Hz";
            pos = "4480 360";
            transform = "normal";
          };
          DP-2 = {
            bg = "#b2b2b2 solid_color";
            mode = "2560x1440@143Hz";
            pos = "1920 0";
            transform = "normal";
          };
          HDMI-A-1 = {
            bg = "#b2b2b2 solid_color";
            mode = "1920x1080@60Hz";
            pos = "0 360";
            transform = "normal";
          };
        };
      };
    };
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

     # waiting on upstream...
     (drawterm.overrideAttrs (finalAttrs: previousAttrs: {
       src = fetchgit {
         url = "git://git.9front.org/plan9front/drawterm";
         rev = "36debf46ac184a22c6936345d22e4cfad995948c";
         sha256 = "ebqw1jqeRC0FWeUIO/HaEovuwzU6+B48TjZbVJXByvA=";
       };
       version = "unstable-2023-06-27";
       makeFlags = [ "CONF=linux" ];
       nativeBuildInputs = [ pkg-config wayland-scanner ];
       buildInputs = [
         pipewire
         wayland-protocols
         wayland
         libxkbcommon
         (wlr-protocols.overrideAttrs (finalAttrs: previousAttrs: {
           version = "unstable-2022-09-05";
           src = fetchFromGitLab {
             domain = "gitlab.freedesktop.org";
             owner = "wlroots";
             repo = "wlr-protocols";
             rev = "4264185db3b7e961e7f157e1cc4fd0ab75137568";
             sha256 = "Ztc07RLg+BZPondP/r6Jo3Fw1QY/z1QsFvdEuOqQshA=";
           };
         }))
       ];
     }))
   ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

