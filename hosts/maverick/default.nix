{ config, pkgs, inputs, ... }:

{
    imports =
        [
            ./hardware-configuration.nix
            inputs.home-manager.nixosModules.home-manager

            #nvidia support
            #../../modules/nvidia-prime-drivers.nix
            ../../modules/backup-cron.nix
	    ../../modules/de/kde.nix
	    ./hosts.nix
        ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    #boot.loader.grub.enable = true;
    #boot.loader.grub.devices = [ "nodev" ];
    #boot.loader.grub.useOSProber = true;
    boot.loader.grub.efiSupport = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.hostName = "maverick";

    networking.networkmanager.enable = true;

    time.timeZone = "Africa/Harare";

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
    font-awesome
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  desktop.kde.enable = true;

  services = {
    openssh.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    nixos-config-backup = {
        enable = true;
        user = "maverick";
    };
  };

  hardware.pulseaudio.enable = false;
  
  users.mutableUsers = true;
  users.users.maverick = {
    isNormalUser = true;
    # hashedPassword = "$y$j9T$kVpObHal.eRqQgNfmk1Pd1$ud0DeuHDj1ytkAZj4xxNf.s4yqfoWFg3QNjNSB7gq82";
    description = "Maverick";
    extraGroups = ["networkmanager" "wheel" "docker" "podman" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
        "maverick" = import ./home.nix;
    };
    backupFileExtension = "backup";
  };

  programs.firefox.enable = true;
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;

    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" "history-substring-search" "thefuck" "podman" "fzf" ];
      theme = "jonathan";
    };
  };
  system.userActivationScripts.zshrc = "fastfetch";
  programs.neovim = {
    defaultEditor = true;
    vimAlias = true;
  };
  services.flatpak.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
	# browsers
	floorp
	# vivaldi
	# vivaldi-ffmpeg-codecs

	# terminal emulators
	kitty

	# text editors
	neovim
	zed-editor
	vscode
	jetbrains-toolbox

	# languages
	rustup
	go_1_22
	nodejs

  # dev
  android-studio
  android-tools


	# misc
	obsidian
	thefuck
	zellij
	distrobox
	tmux
	fastfetch
	deluge
	insomnia
	devbox
	docker-compose
	openssl
	direnv
	fzf

	# entertainment
	spotify
	vlc
  ];

  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
    dockerCompat = true;
  };
  hardware.nvidia-container-toolkit.enable = true;

  security.rtkit.enable = true;


  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # substituters = [ "https://hyprland.cachix.org" ];
      # trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 0;

  system.stateVersion = "24.05"; 
}
