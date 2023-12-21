{ config, ... }:
{
  services.vaultwarden = {
    enable = true;
    backupDir = "${config.services.globalVars.containerDir}/vaultwarden";
    config.ROCKET_PORT = 8222;
  };

  services.nginx.virtualHosts."vault.${config.services.globalVars.domain}" = {
    locations."/".proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
    forceSSL = true;
    enableACME = true;
    acmeRoot = null;
  };

}
