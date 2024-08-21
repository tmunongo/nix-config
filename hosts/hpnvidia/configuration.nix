# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.efiSupport = true;

  networking.hostName = "nix1da"; # Define your hostname.
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

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  boot.initrd.kernelModules = ["nvidia"];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia.prime = {
    sync.enable = true;

  # Make sure to use the correct Bus ID values for your system!
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:6:0:0";
    # amdgpuBusId = "PCI:54:0:0"; For AMD GPU
  };

  services = {
    flatpak.enable = true;
    gnome.gnome-keyring.enable = true;
    openssh.enable = true;
    printing.enable = true;
    xserver = {
      videoDrivers = ["nvidia"];
      enable = true;
      xkb.layout = "us";
      xkb.variant = "";
    };

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
    };
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;

  # Bluetooth Support
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tawanda = {
    isNormalUser = true;
    description = "tawanda";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "tawanda" = import ./home.nix;
    };
    backupFileExtension = "backup";
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.nm-applet.enable = true;
  programs.hyprlock.enable = true;

  # hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # NVIDIA only
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # nix.settings.experimental-features = ["nix-command" "flakes" ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  wget
  git
  gnumake
  ripgrep
  zsh
  zellij
  jetbrains.phpstorm
  curl
  vscode
  neovim
  zed-editor
  distrobox
  wineWowPackages.stable
  winetricks
  lshw
  nodejs
  obsidian
  alacritty
  spotify
  mullvad-vpn
  rustup
  nodejs_22
  python39
  nextcloud-client
  tmux
  vlc
  htop
  libsForQt5.bismuth
  neofetch

  gnome.file-roller
  swaynotificationcenter


  # for hyprland
  waybar # bar
  (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    })
  )
  dunst # notificationd daemon
  libnotify
  swaybg
  kitty
  nwg-dock
  rofi-wayland
  lxqt.lxqt-policykit
  brightnessctl
  swaylock
  networkmanagerapplet
  ];

  # desktop portals for hyprland
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Security / Polkit
  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    })
  '';
  security.pam.services.hyprlock = {
    text = ''
      auth include login
    '';
  };


  # docker
  virtualisation.docker.enable = true;

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

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
  # systemd.user.services.polkit-kde-agent-1 = {
  #  description = "polkit-kde-agent-1";
  #  wantedBy = [ "graphical-session.target" ];
  #  serviceConfig = {
  #    Type = "simple";
  #    ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-agent-1";
  #    Restart = "on-failure";
  #  };
  #};

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


  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
