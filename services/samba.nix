{ config, ... }:
{
  # Samba
  services.samba-wsdd.enable = true;
  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      server string = smbnix
      guest ok = yes
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      public = {
        path = "${config.services.globalVars.dataDir}";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "alistair";
        "force group" = "users";
      };
    };
  };
}
