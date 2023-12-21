{ config, ... }:
let
  port = "777";
in {
  virtualisation.oci-containers.containers = {
    librespeed = {
      image = "lscr.io/linuxserver/librespeed";
      ports = ["${port}:80"];
      volumes = [
        "${config.services.globalVars.dataDir}/containers/librespeed/config:/config"
      ];
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "${config.time.timeZone}";
        PASSWORD = "PASSWORD";
      };
    };
  };

  services.nginx.virtualHosts."speed.${config.networking.fqdn}".locations."/".proxyPass = "http://127.0.0.1:${port}";
}
