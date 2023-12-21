{ config, ... }:
let
  fqdn = "${config.networking.fqdn}";
  port = 4000;
in {
  imports = [ ../modules/dashy.nix ];

  nixpkgs.config.permittedInsecurePackages = [ "nodejs-16.20.2" ];

  services.dashy = {
    enable = true;
    port = port;
    settings = {
      pageInfo = {
        title = "Tiefenbacher";
        navLinks = [
          {
            title = "Documentation";
            path = "https://dashy.to/docs";
          }
        ];
      };
      appConfig = {
        theme = "minimal-dark";
        layout = "horizantal";
        statusCheck = true;
        hideComponents = {
          hideSettings = true;
          hideSearch = true;
        };
      };
      sections = [
        {
          name = "Services";
          icon = "fas fa-house";
          items = [
            {
              title = "Jellyfin";
              url = "http://jellyfin.${fqdn}";
              icon = "si-jellyfin";
            }
            {
              title = "NextCloud";
              url = "http://nextcloud.${fqdn}";
              icon = "si-nextcloud";
            }
            {
              title = "Wiki";
              url = "http://wiki.${fqdn}";
              icon = "si-wikipedia";
            }
            {
              title = "Solar";
              url = "http://192.168.68.102/";
              icon = "fas fa-sun";
            }
            {
              title = "Grafana";
              url = "http://grafana.${fqdn}";
              icon = "si-grafana";
            }
          ];
        }
        {
          name = "Networking";
          icon = "fas fa-wifi";
          items = [
            {
              title = "LibreSpeed";
              url = "http://speed.${fqdn}";
              icon = "si-speedtest";
            }
            {
              title = "SmokePing";
              url = "http://smokeping.${fqdn}/smokeping.fcgi";
              icon = "fas fa-fire";
            }
            {
              title = "AdGuard";
              url = "http://adguard.${fqdn}";
              icon = "si-adguard";
            }
            {
              title = "Router";
              url = "http://192.168.1.1";
              icon = "fas fa-wifi";
            }
            {
              title = "Mesh Network";
              url = "http://192.168.68.1/webpages/index.html";
              icon = "si-tplink";
            }
          ];
        }
        {
          name = "DevOps";
          icon = "fas fa-database";
          items = [
            {
              title = "Portainer";
              icon = "si-portainer";
              url = "https://portainer.tiefenbacher.home/";
            }
          ];
        }
      ];
    };
  };

  services.nginx.virtualHosts."${fqdn}".locations."/".proxyPass = "http://127.0.0.1:${toString port}";
}
