{ config, ... }:
let
    port = 1066;
in {
    services.duplicati = {
        enable = true;
        port = port;
        interface = "any";
    };
    services.nginx.virtualHosts."backup.${config.networking.fqdn}".locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";
        proxyWebsockets = true;
    };
}
