{ pkgs, ... }:
{

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  documentation.man.generateCaches = true;
  security.polkit.enable = true;
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

  fonts.packages = with pkgs; [
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
}
