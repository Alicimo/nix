# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./vim.nix
      services/samba.nix
      services/jellyfin.nix
      services/nextcloud.nix
      services/adguard.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "nixos"; # Define your hostname.
    firewall.enable = false;
    networkmanager.enable = true;
  };
  systemd.services.NetworkManager-wait-online.enable = false;

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  services.xserver = {
    enable = true;

    # Enable the XFCE Desktop Environment.
    desktopManager.xfce.enable = true;
    displayManager = {
      lightdm.enable = true;

      # Enable automatic login for the user.
      autoLogin.enable = true;
      autoLogin.user = "alistair";
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alistair = {
    isNormalUser = true;
    description = "Alistair";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    docker-compose
    git
    git-lfs
    htop
    hwinfo
    iotop
    lm_sensors
    nmap
    tailscale
    unzip
    wget
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.tailscale.enable = true;

  # Enable Docker
  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts = {
      "tiefenbacher.home".locations."/".proxyPass = "http://127.0.0.1:4000";
      "adguard.tiefenbacher.home".locations."/".proxyPass = "http://127.0.0.1:999";
      "jellyfin.tiefenbacher.home".locations."/".proxyPass = "http://127.0.0.1:8096";
      "smokeping.tiefenbacher.home".locations."/".proxyPass = "http://127.0.0.1:888";
      "speed.tiefenbacher.home".locations."/".proxyPass = "http://127.0.0.1:777";
      "wiki.tiefenbacher.home".locations."/".proxyPass = "http://127.0.0.1:6875";
      "portainer.tiefenbacher.home".locations."/".proxyPass = "http://127.0.0.1:9000";
    };
  };

  system.stateVersion = "23.05"; # Did you read the comment?
}
