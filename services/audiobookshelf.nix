{ config, ... }:
let
  dir="${config.services.globalVars.containerDir}/audiobookshelf";
  port="13378";
in {
  virtualisation.oci-containers.containers = {
     audiobookshelf = {
      image = "ghcr.io/advplyr/audiobookshelf";
      volumes = [
        "${dir}/config:/config"
        "${dir}/metadata:/metadata"
        "${config.services.globalVars.mediaDir}/Audiobooks:/audiobooks"
        "${config.services.globalVars.mediaDir}/Podcasts:/podcasts"
      ];
      ports = [ "${port}:80" ];
    };
  };

  services.nginx.virtualHosts."audiobook.${config.networking.fqdn}".locations."/" = {
    proxyPass = "http://127.0.0.1:${port}";
    proxyWebsockets = true;
  };
}
