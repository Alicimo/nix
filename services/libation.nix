{ config, ... }:
{
  virtualisation.oci-containers.containers = {
     libation = {
      image = "rmcrackan/libation";
      volumes = [
        "${config.services.globalVars.containerDir}/libation:/config"
        "${config.services.globalVars.mediaDir}/Audiobooks:/data"
      ];
    };
  };
}
