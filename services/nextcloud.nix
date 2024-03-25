{ pkgs, config, lib, ... }:
let
    fqdn = "nextcloud.${config.services.globalVars.domain}";
in {
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud28;
    hostName = "${fqdn}";
    home = "${config.services.globalVars.containerDir}/nextcloud";
    https = true;
    config = {
      extraTrustedDomains = [ "${fqdn}" ];
      adminpassFile = "${pkgs.writeText "adminpass" "test123"}";
      dbtableprefix = "oc_";
    };
    
    appstoreEnable = true;
    autoUpdateApps.enable = true;

    # extraApps = {
    #   inherit (config.services.nextcloud.package.packages.apps) bookmarks contacts calendar deck onlyoffice tasks;
    #   memories = pkgs.fetchNextcloudApp {
    #     sha256 = "sha256-Xr1SRSmXo2r8yOGuoMyoXhD0oPVm/0/ISHlmNZpJYsg=";
    #     url = "https://github.com/pulsejet/memories/releases/download/v6.2.2/memories.tar.gz";
    #     license = "agpl3";
    #   };
    #   previewgenerator = pkgs.fetchNextcloudApp {
    #     sha256 = "sha256-dUgdrLukyFsvKZRiYUWaHj9b7ljMU4IFJ2UJhfuOwCE=";
    #     url = "https://github.com/nextcloud-releases/previewgenerator/releases/download/v5.4.0/previewgenerator-v5.4.0.tar.gz";
    #     license = "agpl3";
    #   };
    #   recognize = pkgs.fetchNextcloudApp {
    #     sha256 = "sha256-7LuXBz7nrimRRUowu47hADzD5XhVyZP4Z39om8IRAZw=";
    #     url = "https://github.com/nextcloud/recognize/releases/download/v6.0.1/recognize-6.0.1.tar.gz";
    #     license = "agpl3";
    #   };
    # };
    # extraAppsEnable = true;

    extraOptions = {
      "memories.exiftool" = "${lib.getExe pkgs.exiftool}";
    };
  };
  systemd.services.nextcloud-cron = {
    path = [ pkgs.perl ];
  };

  services.nginx.virtualHosts."${fqdn}" = {
    forceSSL = true;
    enableACME = true;
    acmeRoot = null;
  };
}
