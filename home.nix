{ config, pkgs, inputs, ... }:

{

  imports = [
    inputs.home-manager.nixosModules.default
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  environment.pathsToLink = [ "/share/bash-completion" ];
  home-manager.users.moody = { pkgs, fonts, ... }: {
    home.packages = [ ];
    home.stateVersion = "23.05";
    home.sessionVariables = {
      EDITOR = "nvim";
      LESS = "-asrRix8F";
      GRIM_DEFAULT_DIR = "/home/moody/pic/";
      PLAN9 = "${pkgs.plan9port}/plan9";
      XDG_DESKTOP_DIR = "/home/moody/desktop";
      XDG_DOWNLOAD_DIR = "/home/moody/downloads";
    };
    home.shellAliases = {
      "dn" = "makoctl dismiss -a";
      "grimslurp" = ''grim -g "$(slurp)"'';
      "unzip" = "unzrip";
    };

    programs = {
      bash = {
        enable = true;
        historyFile = "$HOME/.history";
        historyControl = [ "erasedups" "ignoredups" "ignorespace" ];
        bashrcExtra = ''
          export PS1="; "
        '';
      };
      neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        coc = {
          enable = true;
          settings = {
            languageserver = {
              nix = {
                command = "nil";
                filetypes = [ "nix" ];
                rootPatterns = [ "flake.nix" ];
                settings.nil.formatting.command = [ "nixpkgs-fmt" ];
              };
              go = {
                command = "gopls";
                filetypes = [ "go" ];
                rootPatterns = [ "go.work" "go.mod" ".vim/" ".git/" ".hg/" ];
              };
            };
            coc.preferences.formatOnSaveFiletypes = [ "nix" "go" ];
          };
        };

        extraConfig =
          ''
            set termguicolors
            set clipboard=unnamedplus
          '';

        plugins = with pkgs.vimPlugins; [
          { plugin = vacme-vim; config = "colorscheme vacme"; }
          {
            plugin = nvim-lastplace;
            config = ''
              lua require'nvim-lastplace'.setup{}
              let g:lastplace_ignore_buftype = "quickfix,nofile,help"
              let g:lastplace_ignore_filetype = "gitcommit,gitrebase,svn,hgcommit"
              let g:lastplace_open_folds = 1
            '';
          }
          vim-go
        ];
      };
      foot = {
        enable = true;
        settings = {
          main = {
            term = "xterm-256color";
            font = "VGA:size=12";
            font-bold = "VGA:size=12";
            font-italic = "VGA:size=12";
          };
          cursor.color = "45363b 45363b";
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

    services = {
      mako = {
        enable = true;
        font = "VGA 12";
        anchor = "top-left";
        output = "DP-1";
        backgroundColor = "#FFFFFFFF";
        textColor = "#000000FF";
        borderColor = "#55aaaaFF";
        borderSize = 4;
        format = "%s\\n%b";
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
      config = {
        modifier = "Mod4";
        terminal = "foot";
        bars = [ ];
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
          { title = "[.]*"; }
          { app_id = "[.]*"; }
          { class = "[.]*"; }
        ];
        output = {
          "sakuya" = {
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
          "marisa"."*".bg = "#b2b2b2 solid_color";
        }."${config.networking.hostName}";
      };
    };
  };


}
