{ config, ... }:
{
  services.openvscode-server = {
    enable = true;
    port = 3210;
    withoutConnectionToken = true;
    user = "alistair";
    host = "127.0.0.1";
  };
  services.nginx.virtualHosts."code.${config.networking.fqdn}".locations."/" = {
    proxyPass = "http://127.0.0.1:${toString config.services.openvscode-server.port}";
    proxyWebsockets = true;
  };
}
# 