{ config, ... }:
{
  services.adguardhome = {
    enable = true;
    settings = {
      bind_port = 999;
      dns = {
        filters_update_interval = 1;
        upstream_dns = ["1.1.1.2" "1.0.0.2" "94.140.14.14" "94.140.15.15"];
        all_servers = true;
        fastest_addr = false;
        bootstrap_dns = [];
        cache_optimistic = true;
        rewrites = [
          {
            domain = "${config.networking.fqdn}";
            answer = "100.94.208.53";
          }
          {
            domain = "*.${config.networking.fqdn}";
            answer = "100.94.208.53";
          }
        ];
      };
      filters = [
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
          name = "AdGuard DNS filter";
          id = 1;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_2.txt";
          name = "AdAway Default Blocklist";
          id = 2;
        }
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_27.txt";
          name = "OISD Blocklist Big";
          id = 1693232049;
        }
      ];
    };
  };

  services.nginx.virtualHosts."adguard.${config.networking.fqdn}".locations."/".proxyPass = "http://127.0.0.1:${toString config.services.adguardhome.settings.bind_port}";
}
