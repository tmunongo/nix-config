# default.nix

{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-24.05";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager }: {

    # Example configuration for Home Manager
    homeConfigurations = {
      tawanda = home-manager.buildHome {
        # Specify the users you want to manage here
        users = [ {
          name = "tawanda";
          home.stateVersion = "24.05";
          packages = pkgs: [
            pkgs.vim
            pkgs.neovim
          ];
          home.file.".bashrc".text = ''
            export PATH=$HOME/.local/bin:$PATH
          '';
          home.services = [
            {
              type = "package";
              name = "firefox";
              state = "latest";
            }
          ];
        } ];
      };
    };

    # Output for the system configuration
    nixosConfigurations = {
      hpnvidia = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hardware-configuration.nix
          home-manager.nixosModules.hpnvidia
        ];
      };
    };
  };
}

