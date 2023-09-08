{ pkgs, ... }:
{
  # AdGuard Home
  services.adguardhome = {
    enable = true;
    settings.bind_port = 999;
  };
}

