# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
{
  nixpkgs.overlays = [ (final: prev: { dashy = prev.callPackage overlays/dashy.nix prev; } ) ];

  imports =
    [
      ./hardware-configuration.nix
      ./vim.nix
      modules/vars.nix
      services/samba.nix
      services/jellyfin.nix
      services/nextcloud.nix
      services/adguard.nix
      services/grafana.nix
      services/prometheus.nix
      services/fronius.nix
      services/smokeping.nix
      services/vaultwarden.nix
      services/dashy.nix
      services/librespeed.nix
      services/libation.nix
      services/audiobookshelf.nix
      services/freshrss.nix
      services/vscode_server.nix
      services/photoview.nix
      services/whoogle.nix
      services/duplicati.nix
#      services/home_assistant.nix
    ];

  services.globalVars.dataDir = "/mnt/data";
  services.globalVars.domain = "alistair-martin.com";


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "tiefenbacher";
    domain = "home";
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
    lsof
    dig
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };

  # Containers
  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
    };
    podman = {
      enable = true;
      autoPrune.enable = true;
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "contact@alistair-martin.com";
      group = "nginx";
      dnsProvider = "cloudflare";
      credentialsFile = "/etc/nixos/secrets/cloudflare.env";
    };
  };

  system.stateVersion = "23.05"; # Did you read the comment?
}
