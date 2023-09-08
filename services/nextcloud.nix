{ pkgs, config, ... }:
{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud27;
    hostName = "nextcloud.tiefenbacher.home";
    config.adminpassFile = "${pkgs.writeText "adminpass" "test123"}";
    extraApps = with config.services.nextcloud.package.packages.apps; {
      inherit bookmarks contacts calendar deck keeweb mail notes onlyoffice polls tasks;
    };
    extraAppsEnable = true;
  };
}
