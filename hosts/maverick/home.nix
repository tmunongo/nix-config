{ config, pkgs, ... }:

{
  home.username = "maverick";
  home.homeDirectory = "/home/maverick";

  imports = [];

  home.file.".config/fastfetch" = {
    source = ../../config/fastfetch;
    recursive = true;
  };

  home.stateVersion = "24.05";

  #qt = {
  #  enable = true;
  #  style.name = "adwaita-dark";
  #  platformTheme.name = "gtk3";
  #};

  home.packages = with pkgs; [
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    koodo-reader
  ];

  home.file = {
    # ".screenrc".source = dotfiles/screenrc;    
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.home-manager.enable = true;
}
