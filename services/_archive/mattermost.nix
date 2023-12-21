{ config, ... }:
let
  fqdn = "chat.${config.networking.fqdn}";
in {
  services.mattermost = {
    enable = true;
    siteUrl = "http://${fqdn}";
  };

  services.nginx.virtualHosts."${fqdn}".locations."/" = {
    proxyPass = "http://127.0.0.1${config.services.mattermost.listenAddress}";
    proxyWebsockets = true;
  };
}
