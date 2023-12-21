{ config, ... }:
let
  fqdn =  "grafana.${config.networking.fqdn}";
in {
  services.grafana = {
    enable = true;
    settings.server = {
      domain = "${fqdn}";
    };
  };

  services.nginx.virtualHosts."${fqdn}".locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
        proxyWebsockets = true;
  };
}
