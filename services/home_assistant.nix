{ config, ... }:
{
    services.home-assistant = {
        enable = true;
        extraComponents = [
            "met"
            "fronius"
            "tradfri"
            "tplink"
            "roomba"
            "brother"
            "apple_tv"
            "radio_browser"
            "zha"
            "mobile_app"
            "hassio"
        ];
        extraPackages = python3Packages: with python3Packages; [
            pyatv
            aiohomekit
            getmac
            python-otbr-api
            pyipp
        ];
        config = {

            default_config = {};
            http = {
                server_host = "::1";
                trusted_proxies = [ "::1" ];
                use_x_forwarded_for = true;
            };
            "automation manual" = [];
            "automation ui" = "!include automations.yaml";
            "scene manual" = [];
            "scene ui" = "!include scenes.yaml";
        };
    };

    systemd.tmpfiles.rules = [
        "f ${config.services.home-assistant.configDir}/automations.yaml 0755 hass hass"
        "f ${config.services.home-assistant.configDir}/scenes.yaml 0755 hass hass"
    ];

    nixpkgs.config.permittedInsecurePackages = [ "openssl-1.1.1w" ];

    services.nginx.virtualHosts."hass.${config.services.globalVars.domain}" = {
        forceSSL = true;
        enableACME = true;
        acmeRoot = null;
        extraConfig = ''
        proxy_buffering off;
        '';
        locations."/" = {
            proxyPass = "http://[::1]:8123";
            proxyWebsockets = true;
        };
    };
}
