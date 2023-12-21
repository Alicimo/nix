{ pkgs, config, ... }:
let
    fqdn = "nextcloud.${config.services.globalVars.domain}";
in {
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud27;
    hostName = "${fqdn}";

    extraApps = with config.services.nextcloud.package.packages.apps; {
      inherit bookmarks contacts calendar deck mail notes onlyoffice tasks;
    };
    extraAppsEnable = true;
    autoUpdateApps.enable = true;
    home = "${config.services.globalVars.containerDir}/nextcloud";
    https = true;
    config = {
      extraTrustedDomains = [ "${fqdn}" ];
      adminpassFile = "${pkgs.writeText "adminpass" "test123"}";
    };
  };

  services.nginx.virtualHosts."${fqdn}" = {
    forceSSL = true;
    enableACME = true;
    acmeRoot = null;
  };

}
