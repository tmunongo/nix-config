{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.zapiet-dev;
in {
  options.services.zapiet-dev = {
    enable = mkEnableOption "my zapiet distrobox development environment";
    
    image = mkOption {
      type = types.str;
      default = "ubuntu:22.04";
      description = "The container image to use for the distrobox";
    };
    
    packages = mkOption {
      type = types.listOf types.str;
      default = [ "docker-compose" "php" "composer" ];
      description = "Packages to install in the distrobox";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
    #environment.systemPackages = with pkgs; [ distrobox ];
    
    system.activationScripts.setupDistrobox = ''
      ${pkgs.distrobox}/bin/distrobox create --name zapiet-dev --image ${cfg.image} || true
      ${pkgs.distrobox}/bin/distrobox enter zapiet-dev -- sudo apt update
      ${pkgs.distrobox}/bin/distrobox enter zapiet-dev -- sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
      ${pkgs.distrobox}/bin/distrobox enter zapiet-dev -- sudo apt install -y ${concatStringsSep " " cfg.packages}
    '';
    
    # users.users.${config.users.users.tawanda.name}.extraGroups = [ "docker" ];
  };
}
