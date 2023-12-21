{ config, ... }:
let
  port = "9443";
in {
  virtualisation.oci-containers.containers = {
     portainer = {
      image = "portainer/portainer-ce";
      ports = [
        "${port}:9443"
      ];
      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock"
        "portainer_data:/data"
      ];
      extraOptions = ["--privileged"];
    };
  };

  services.nginx.virtualHosts."portainer.${config.networking.fqdn}" = {
    locations."/".proxyPass = "http://127.0.0.1:${port}";
    enableACME = true;
    forceSSL = true;
  };
}
