{ config, pkgs,... }:
let
    port = "5000";
in {
    virtualisation.oci-containers.containers.whoogle = {
        image = "benbusby/whoogle-search";
        ports = [ "${port}:5000" ];
        environment = {
            WHOOGLE_CONFIG_LANGUAGE = "lang_en";
            WHOOGLE_CONFIG_SEARCH_LANGUAGE = "lang_en";
            WHOOGLE_CONFIG_COUNTRY = "AT";
        };
    };
    services.nginx.virtualHosts."search.${config.networking.fqdn}".locations."/".proxyPass = "http://127.0.0.1:${port}";
}
