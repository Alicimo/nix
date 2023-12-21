{ config, ... }:
{
  services.prometheus = {
    enable = true;
    port = 3001;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ 
          "systemd"
          "processes"
        ];
        port = 3002;
      };
    };
    scrapeConfigs = [
      {
        job_name = "prometheus";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.port}" ];
        }];
      }
      {
        job_name = "usage";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      }
      {
        job_name = "solar";
        static_configs = [{
          targets = [ "127.0.0.1:3003" ];
        }];
      }
    ];
  };
}
