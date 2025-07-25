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
      ./hardware.nix
      ../../modules/de/gnome.nix
      ../../modules/de/kde.nix
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
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options kvm_intel emulate_invalid_guest_state=0
    options kvm ignore_msrs=1
  '';

  swapDevices = [{
    device = "/swapfile";
    size = 8 * 1024; # 8GB
  }];

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

  fonts = {
    fontconfig.enable = true;
    fontDir.enable = true;
    packages = with pkgs; [
      dejavu_fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      freefont_ttf
      twitter-color-emoji
      wqy_zenhei
      wqy_microhei
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      arphic-ukai
      arphic-uming
      font-awesome
    ];
  };

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.bluetooth.enable = true;
  
  desktop.gnome.enable = false;
  desktop.kde.enable = true;

  services = {
    flatpak.enable = true;
    openssh.enable = true;
    printing.enable = true;
    # mullvad-vpn.enable = true;

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
  # hardware.pulseaudio.enable = false;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tawanda = {
    isNormalUser = true;
    description = "tawanda";
    extraGroups = [ 
      "networkmanager" "wheel" "libvirtd" "incus-admin"
    ];
    shell = pkgs.fish;
    packages = with pkgs; [
      thunderbird
    ];
  };

  users.groups.libvirtd.members = ["tawanda"];
 
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "tawanda" = import ./home.nix;
    };
    backupFileExtension = "bckup";

  };

  programs = {
        # Install firefox.
  	firefox.enable = true;
	# wireshark.enable = true;
        neovim = {
          enable = true;
          defaultEditor = true;
        };
	fish = {
	  enable = true;
	};	
#	zsh = {  
#          enable = true;
#          ohMyZsh = {
#            enable = true;
#            plugins = [ "git" "sudo" "docker" "history-substring-search" "thefuck" ];
#            theme = "jonathan";
#          };
#        };
	virt-manager.enable = true;
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
    	# seahorse.enable = true;
	nix-ld = {
	  enable = true;
	  libraries = [];
	};
  };

  # Allow unfree packages
  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "electron-29.4.6"
      ];
    };
  };

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

  # code editors 
  zed-editor
  vscode
  ghostty
  windsurf

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
  yt-dlp
  # unetbootin
  # smartmontools

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
  devbox
  # devenv
  sqlite
  distrobox
  # virtualbox
  # vagrant
  # ansible
  # qemu
  dmg2img
  railway

  # programming  
  python313
  # ruby_3_3
  # rubyPackages_3_3.racc
  # flutter
  # jdk22
  # gradle
  nodejs_23
  
  # software
  obsidian
  # mullvad-vpn
  # nextcloud-client
  kitty
  teams-for-linux
  # podman-desktop # not being updated
  podman-compose
  deluge
  # patchelf
  insomnia
  # rpi-imager
  fastfetch
  flameshot
  appimage-run
  gnome-disk-utility
  
  # photo editors
  # darktable
  # gimp
  # pinta
  # inkscape-with-extensions

  # entertainment
  vlc
  spotify
  # strawberry
  spotdl
  
  # browsers
  chromium
  # arc-browser
  # floorp
  
  jetbrains.phpstorm
  # Android
  # android-studio
  # android-tools
  # libreoffice

  # beekeeper-studio
  ];


  # desktop portals for hyprland
  # xdg.portal = {
  #   enable = true;
  # };

  # Security / Polkit
  security.rtkit.enable = true;
  security.protectKernelImage = false;

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
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [(pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd];
      };
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.incus.enable = true;

  virtualisation.incus.preseed = {  
    networks = [
      {
        config = {
          "ipv4.address" = "10.0.100.1/24";
          "ipv4.nat" = "true";
        };
        name = "incusbr0";
        type = "bridge";
      }
    ];
    profiles = [
      {
        devices = {
	  eth0 = {
            name = "eth0";
            network = "incusbr0";
            type = "nic";
          };
          root = {
            path = "/";
            pool = "default";
            size = "35GiB";
            type = "disk";
          };
        };
      name = "default";
      }
  ];
    storage_pools = [
      {
        config = {
          source = "/var/lib/incus/storage-pools/default";
        };
        driver = "dir";
        name = "default";
      }
    ];
  };
  # virtualisation.lxd = {
  #   enable = true;
  #   preseed = {
  #     networks = [
  #       {
  #         name = "lxdbr0";
  #         type = "bridge";
  #         config = {
  #           "ipv4.address" = "10.0.100.1/24";
  #           "ipv4.nat" = "true";
  #         };
  #       }
  #     ];
  #     profiles = [
  #       {
  #         name = "default";
  #         devices = {
  #           eth0 = {
  #             name = "eth0";
  #             network = "lxdbr0";
  #             type = "nic";
  #           };
  #           root = {
  #             path = "/";
  #             pool = "default";
  #             size = "35GiB";
  #             type = "disk";
  #           };
  #         };
  #       }
  #     ];
  #     storage_pools = [
  #       {
  #         name = "default";
  #         driver = "dir";
  #         config = {
  #           source = "/var/lib/lxd/storage-pools/default";
  #         };
  #       }
  #     ];
  #   };  
  # };

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
    extraOptions = ''
        trusted-users = root tawanda
    '';
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.trustedInterfaces = [ "incusbr0" "virbr0" ];
  networking.nftables.enable = true;
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # temporary solution for docker rootless issue
  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 80;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
