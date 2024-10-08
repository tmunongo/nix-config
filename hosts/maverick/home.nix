{ config, pkgs, ... }:

{
  home.username = "maverick";
  home.homeDirectory = "/home/maverick";

  imports = [
    ../../config/neovim.nix
  ];

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
    whitesur-kde
    whitesur-icon-theme
  ];

  home.file = {
    # ".screenrc".source = dotfiles/screenrc;    
  };

  programs.home-manager.enable = true;
}
