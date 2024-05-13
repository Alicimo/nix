{ config, ... }:
let
  port="2542";
in {
  services.uptime-kuma = {
    enable = true;
    settings = {
      PORT=port;
    };
  };
  services.nginx.virtualHosts = {
    "uptime.${config.networking.fqdn}".locations."/".proxyPass = "http://127.0.0.1:${port}";
    "${config.networking.fqdn}".locations."/".proxyPass = "http://127.0.0.1:${port}";
  };
}
