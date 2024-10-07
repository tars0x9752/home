# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  nix.settings.auto-optimise-store = true;

  # see https://nixos.wiki/wiki/Storage_optimization#Pinning
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';

  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.

  # ↓ networkmanager を使うので不要
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.utf8";
    LC_IDENTIFICATION = "ja_JP.utf8";
    LC_MEASUREMENT = "ja_JP.utf8";
    LC_MONETARY = "ja_JP.utf8";
    LC_NAME = "ja_JP.utf8";
    LC_NUMERIC = "ja_JP.utf8";
    LC_PAPER = "ja_JP.utf8";
    LC_TELEPHONE = "ja_JP.utf8";
    LC_TIME = "ja_JP.utf8";
  };

  services = {
    xserver = {
      enable = true;
      desktopManager.xterm.enable = false;

      # home-manager 側で i3 の設定するために必要
      desktopManager.session = [
        {
          name = "home-manager";
          start = ''
            ${pkgs.runtimeShell} $HOME/.hm-xsession &
            waitPID=$!
          '';
        }
      ];

      xkb.layout = "jp";
      xkb.variant = "OADG109A";
      videoDrivers = [ "nvidia" ];

      exportConfiguration = true;
    };

    logind.lidSwitch = "ignore";
  };

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;

  hardware.nvidia.prime = {
    # 基本的に nvidia カードに接続した外付けディスプレイを常に使用するので offload ではなく sync mode にしておく
    sync.enable = true;

    # Bus ID は lspci 等で確認できる
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # hardware.opengl.enable = true;

  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  # Configure console keymap
  console.keyMap = "jp106";

  # docker
  virtualisation.docker.enable = true;

  nix.settings.trusted-users = [ "root" "tars" ];

  users.users.tars = {
    isNormalUser = true;
    description = "tars";
    extraGroups = [ "networkmanager" "wheel" "audio" "docker" ];
    packages = with pkgs; [ ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # 最低限, home-manager がインストール済みかつ git と gnumake があれば dotfiles を git clone してきて make switch できる
    git
    gnumake
    wget
    curl
    pavucontrol
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

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
  system.stateVersion = "22.05"; # Did you read the comment?
}
