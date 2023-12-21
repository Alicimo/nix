{ config, ... }:
let
  fqdn = "rss.${config.services.globalVars.domain}";
  dir = "${config.services.globalVars.containerDir}/freshrss";
in {
  services.freshrss = {
    enable = true;
    baseUrl = "https://${fqdn}";
    passwordFile = "${dir}/secret";
    database.port = 3306;
    virtualHost = "${fqdn}";
    dataDir = "${dir}";
  };
  services.nginx.virtualHosts."${fqdn}" = {
    forceSSL = true;
    enableACME = true;
    acmeRoot = null;
  };
}
