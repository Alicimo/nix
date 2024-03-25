{ config, ... }:
{
  services.paperless = {
    enable = true;
    dataDir = "${config.services.globalVars.dataDir}/paperless";
    passwordFile = "/etc/nixos/secrets/paperless-password";
    consumptionDirIsPublic = true;
    extraConfig = {
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_AUTO_LOGIN_USERNAME = "admin";
    };
  };
  services.nginx.virtualHosts."paperless.${config.services.globalVars.domain}" = {
    locations."/".proxyPass = "http://127.0.0.1:${toString config.services.paperless.port}";
    forceSSL = true;
    enableACME = true;
    acmeRoot = null;
  };
}
