{ config, ... }:
{
  services.dokuwiki.sites."wiki.${config.networking.fqdn}" = {
    enable = true;
    settings = {
      title = "Tiefenbacher Wiki";
      useacl = false;
    };
  };
}
