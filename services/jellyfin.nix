{ pkgs, config, ... }:
{
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      jellyfin-ffmpeg
    ];
  };

  services.jellyfin.enable = true;

  services.nginx.virtualHosts."jellyfin.${config.networking.fqdn}".locations."/".proxyPass = "http://127.0.0.1:8096";
  services.nginx.virtualHosts."jellyfin.${config.services.globalVars.domain}" = {
    locations."/".proxyPass = "http://127.0.0.1:8096";
    forceSSL = true;
    enableACME = true;
    acmeRoot = null;
  };
}
