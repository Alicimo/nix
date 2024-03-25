{ config, pkgs,... }:
let
  port = "4001";
  dir = "${config.services.globalVars.containerDir}/photoview";
in {
/*  systemd.services.create-photoview-pod = with config.virtualisation.oci-containers; {
    serviceConfig.Type = "oneshot";
    wantedBy = [ "${backend}-photoview.service" "${backend}-db.service" ];
    script = ''
      ${pkgs.podman}/bin/podman pod exists pv-pod || \
      ${pkgs.podman}/bin/podman pod create --name pv-pod --publish '127.0.0.1:222:80'
      '';
  };
  */

  virtualisation.oci-containers.containers = {
    db = {
      image = "mariadb:10.5";
      environment = {
        MYSQL_DATABASE = "photoview";
        MYSQL_USER = "photoview";
        MYSQL_PASSWORD = "photosecret";
        MYSQL_RANDOM_ROOT_PASSWORD = "1";
      };
      volumes = ["${dir}/db_data:/var/lib/mysql"];
      extraOptions = [ "--network=host" ];
    };
    photoview = {
      image = "viktorstrate/photoview:2";
      volumes = [
        "${dir}/cache:/app/cache"
        "${config.services.globalVars.mediaDir}/Photos:/photos:ro"
      ];
      dependsOn = ["db"];
      environment = {
        PHOTOVIEW_DATABASE_DRIVER = "mysql";
        PHOTOVIEW_MYSQL_URL = "photoview:photosecret@tcp(localhost)/photoview";
        PHOTOVIEW_LISTEN_IP = "photoview";
        PHOTOVIEW_LISTEN_PORT = "${port}";
        PHOTOVIEW_MEDIA_CACHE = "/app/cache";
      };
      extraOptions = [ "--network=host" ];
    };
  };
  services.nginx.virtualHosts."photos.${config.networking.fqdn}".locations."/".proxyPass = "http://127.0.0.1:${port}";
}
