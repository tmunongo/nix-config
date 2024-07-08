{
  lib,
  host,
  config,
  pkgs,
  ...
}:

with lib;

{
  programs.neofetch = {
    enable = true;
    package = pkgs.waybar;
    extraConfig = 
    concatStrings [
      ''
        print_info(
          info "Days in NixOS" distro_install
          info "Days on GNOME" de_install
	)


distro_install() {
    install_date=$(ls -lct /etc | tail -1 | awk '{print $6, $7, $8}')
    echo "$(date -d "$install_date" +'%Y-%m-%d') ($(( ($(date +%s) - $(date -d "$install_date" +%s)) / 86400 )) days)"
}

de_install() {
    de_date=$(ls -lct /usr/share/xsessions | tail -1 | awk '{print $6, $7, $8}')
    echo "$(date -d "$de_date" +'%Y-%m-%d') ($(( ($(date +%s) - $(date -d "$de_date" +%s)) / 86400 )) days)"
}
      ''
    ];
  };
}
