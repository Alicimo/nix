{ config, ... }:
let
  dir="${config.services.globalVars.containerDir}/stirling";
  port="1966";
in {
  virtualisation.oci-containers.containers = {
     stirling = {
      image = "frooodle/s-pdf";
      volumes = [
        "${dir}/trainingData:/usr/share/tessdata" #Required for extra OCR languages
        "${dir}/extraConfigs:/configs"
      ];
      ports = [ "${port}:8080" ];
    };
  };

  services.nginx.virtualHosts."pdf.${config.networking.fqdn}".locations."/".proxyPass = "http://127.0.0.1:${port}";
}
