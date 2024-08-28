# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

# let
  # Import flake's nixpkgs
#  unstablePkgs = import "${config.inputs.nixpkgs}/nixos" { config = config.nixpkgs.config; };
# in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/de/gnome.nix
      ./hosts.nix
      ../../modules/backup-cron.nix
      #./zapiet-box.nix
      inputs.home-manager.nixosModules.home-manager
    ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.efiSupport = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "yoga1da"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Harare";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_ZW.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_ZW.UTF-8";
    LC_IDENTIFICATION = "en_ZW.UTF-8";
    LC_MEASUREMENT = "en_ZW.UTF-8";
    LC_MONETARY = "en_ZW.UTF-8";
    LC_NAME = "en_ZW.UTF-8";
    LC_NUMERIC = "en_ZW.UTF-8";
    LC_PAPER = "en_ZW.UTF-8";
    LC_TELEPHONE = "en_ZW.UTF-8";
    LC_TIME = "en_ZW.UTF-8";
  };

  fonts.packages = with pkgs; [
    dejavu_fonts
    noto-fonts
    freefont_ttf
    noto-fonts-emoji
    twitter-color-emoji
    wqy_zenhei
    wqy_microhei
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    arphic-ukai
    arphic-uming
    font-awesome
  ];

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  
  desktop.gnome.enable = true;

  services = {
    flatpak.enable = true;
    openssh.enable = true;
    printing.enable = true;
    mullvad-vpn.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
  
      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;

      # backup configs
    };

    nixos-config-backup = {
      enable = true;
      user = "tawanda";
    };
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tawanda = {
    isNormalUser = true;
    description = "tawanda";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      thunderbird
    ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "tawanda" = import ./home.nix;
    };
    backupFileExtension = "bkp";

  };

  programs = {
        # Install firefox.
  	firefox.enable = true;
	wireshark.enable = true;
        neovim = {
          enable = true;
          defaultEditor = true;
        };
	zsh = {  
          enable = true;
          ohMyZsh = {
            enable = true;
            plugins = [ "git" "sudo" "docker" "history-substring-search" "thefuck" ];
            theme = "jonathan";
          };
        };
	starship = {
          enable = true;
          settings = {
            add_newline = false;
	    command_timeout = 1000;
            buf = {
              symbol = " ";
            };
          c = {
            symbol = " ";
          };
          directory = {
            read_only = " 󰌾";
          };
          docker_context = {
            symbol = " ";
          };
          fossil_branch = {
            symbol = " ";
          };
          git_branch = {
            symbol = " ";
          };
          golang = {
            symbol = " ";
          };
        hg_branch = {
          symbol = " ";
        };
        hostname = {
          ssh_symbol = " ";
        };
        lua = {
          symbol = " ";
        };
        memory_usage = {
          symbol = "󰍛 ";
        };
        meson = {
          symbol = "󰔷 ";
        };
        nim = {
          symbol = "󰆥 ";
        };
        nix_shell = {
          symbol = " ";
        };
        nodejs = {
          symbol = " ";
        };
        ocaml = {
          symbol = " ";
        };
        package = {
          symbol = "󰏗 ";
        };
        python = {
          symbol = " ";
        };
        rust = {
          symbol = " ";
        };
           swift = {
              symbol = " ";
           };
            zig = {
              symbol = " ";
            };
          };
    	};
	dconf.enable = true;
    	seahorse.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.variables = {
    EDITOR = "vi";
    SUDO_EDITOR = "vi";
    PATH="$HOME/go/bin/";
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  
  # Text Editors
  neovim
  helix

  # code editors 
  jetbrains.phpstorm
  vscode
  zed-editor

  # unix tools
  wget
  fzf
  ripgrep
  curl
  lshw
  zsh
  tmux
  thefuck
  htop
  neofetch
  distrobox
  zellij
  youtube-tui

  # dev tools
  git
  gnumake
  openssl
  libgcc
  clang
  wineWowPackages.stable
  winetricks
  dive
  oha
  zstd
  wails
  bun
  templ
  devbox

  # programming  
  nodejs
  rustup
  nodejs_22
  python39
  ruby_3_3
  rubyPackages_3_3.racc
  go
  shopify-cli
  
  # software
  obsidian
  mullvad-vpn
  nextcloud-client
  kitty
  teams-for-linux
  podman-desktop
  podman-compose
  deluge
  # patchelf
  insomnia
  # rpi-imager
  fastfetch

  # entertainment
  vlc
  spotify
  strawberry
  tidal-dl
  
  # browsers
  chromium
  floorp

  # Android
  # android-studio
  # android-tools
  ];

  # desktop portals for hyprland
  xdg.portal = {
    enable = true;
  };

  # Security / Polkit
  security.rtkit.enable = true;

  # docker
  # virtualisation.docker = {
  #  enable = true;
    # listenOptions = [ "/var/run/docker.sock" ];
  #};
  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
    defaultNetwork.settings.dns_enabled = true;
    dockerCompat = true;
  };
  # virtualisation.docker.rootless = {
  #   enable = true;
  #  setSocketVariable = true;
  # };

  # allow using privileged ports
  # security.wrappers = {
  #   docker-rootlesskit = {
  #     owner = "root";
  #     group = "root";
  #     capabilities = "cap_net_bind_service+ep";
  #     source = "${pkgs.rootlesskit}/bin/rootlesskit";
  #   };
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # flatpak services
  #services.flatpak.packages = [
  #  { appId = "one.ablaze.floorp"; origin = "flathub"; }
  #  "org.winehq.wine"
  #  "com.usebottles.bottles"
  #]

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # temporary solution for docker rootless issue
  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 443;
  # custom certificates esp for work
  security.pki.certificates = 
  [ 
    ''
    -----BEGIN CERTIFICATE-----
MIIDLzCCAhegAwIBAgIUAp23LaKKd5ZpkEzoeftnIHG0PdkwDQYJKoZIhvcNAQEL
BQAwJzELMAkGA1UEBhMCVVMxGDAWBgNVBAMMD0V4YW1wbGUtUm9vdC1DQTAeFw0y
NDAzMjcxMTQyNThaFw0yNzAxMTUxMTQyNThaMCcxCzAJBgNVBAYTAlVTMRgwFgYD
VQQDDA9FeGFtcGxlLVJvb3QtQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
AoIBAQC1qovbr4Dp6aa7p3qawZ3WFf8EWnpxQ8BduiEc7TlQ8ap1YuNW9WPv0O2H
dkDxHRaRxU0Jb+L2Li5d2cnvamtDU2u+hyGDPOc3fHn/MVZTCwHoGEIpvsFt+toW
iC9UbsL8YLeI6exsAH9fhr0N3f8GkkwFMT9qZN7t8Z80zOfwEBTg4/37GYmag5S5
J+BQRhAC4kon6bLIYKB57Iu9e41m/bTHDDo4xHK3L2h6LZ4P7CoJGJHLh44wOgx6
hGOzX3gMymz942cpsuIgbkvWNT5eD7K7pmatprwP9YqzlD6/bB6byETysfGMXz4V
JHypRcsmtdWAJ3MmGQejZ3HQEYS7AgMBAAGjUzBRMB0GA1UdDgQWBBQNxEotOASQ
mLeipwLCm6hBGuLoCzAfBgNVHSMEGDAWgBQNxEotOASQmLeipwLCm6hBGuLoCzAP
BgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3DQEBCwUAA4IBAQCWYxN7dqWMZO7fopAP
uUU5B2CTnCwBmXn9TO9ZDAbSIoMKqYDIncZ5NjiDoL5ODOMYa024m+nQqo8Zyuxq
SPJ1wrO1PNIFxGanaO+aJ1HM8QMfgOL0j2o4ryY9pYS8IiOgv7E1uOf6h1BzPbHo
Bbx1UFVApsEMGjsrPVkXy9xUljBh83s26cRQpEPMC65CkieX7t4SVZYEEZG7c54X
b4soIpRa0FNPd3snIHu+hbYQeJvhh+UdRdVu+TlEP/UvMc4NsSImidYapnAuBRaf
HhckOoPBmkcM9lvd9c399reWM9hzbqwXsBhrJ75ncbz7raMTi0FGmWWUOWxZzd4j
XVkt
-----END CERTIFICATE-----
    ''
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
