{ config, ... }:
let
    dir="/mnt/data/containers/home_assistant";
    port="8123"; # You can alter within HA config. This is default.
in {  
    virtualisation.oci-containers = {
    containers.homeassistant = {
      volumes = [ "${dir}:/config" ];
      environment.TZ = "${config.time.timeZone}";
      image = "ghcr.io/home-assistant/home-assistant:stable";
      extraOptions = [ 
        "--privileged"
        "--network=host" 
        # "--device=/dev/ttyACM0:/dev/ttyACM0"  # TODO: Install Combee USB here
      ]; 
    };
  };

  services.nginx.virtualHosts."hass.tiefenbacher.home" = {
    extraConfig = ''
      proxy_buffering off;
    '';
    locations."/".extraConfig = ''
      proxy_pass http://127.0.0.1:8123;
      proxy_set_header Host $host;
      proxy_redirect http:// https://;
      proxy_http_version 1.1;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection $connection_upgrade;
    '';
  };
}