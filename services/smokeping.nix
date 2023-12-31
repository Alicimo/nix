{ config, pkgs, ... }:
let
  fqdn = "smokeping.${config.networking.fqdn}";
in {
  services.smokeping = {
    enable = true;
    port = 888;
    hostName = "${fqdn}";
    targetConfig = ''
      probe = FPing
      menu = Top
      title = Network Latency Grapher
      remark = Welcome to the SmokePing website of homelab

      + InternetSites
      menu = Internet Sites
      title = Internet Sites

      ++ Facebook
      menu = Facebook
      title = Facebook
      host = facebook.com

      ++ Youtube
      menu = YouTube
      title = YouTube
      host = youtube.com

      ++ GoogleSearch
      menu = Google
      title = google.com
      host = google.com

      ++ Github
      menu = Github
      title = Github
      host = www.github.com

      + DNS
      menu = DNS
      title = DNS

      ++ GoogleDNS1
      menu = Google DNS 1
      title = Google DNS 8.8.8.8
      host = 8.8.8.8

      ++ GoogleDNS2
      menu = Google DNS 2
      title = Google DNS 8.8.4.4
      host = 8.8.4.4

      ++ OpenDNS1
      menu = OpenDNS1
      title = OpenDNS1
      host = 208.67.222.222

      ++ OpenDNS2
      menu = OpenDNS2
      title = OpenDNS2
      host = 208.67.220.220

      ++ CloudflareDNS1
      menu = Cloudflare DNS 1
      title = Cloudflare DNS 1.1.1.1
      host = 1.1.1.1

      ++ CloudflareDNS2
      menu = Cloudflare DNS 2
      title = Cloudflare DNS 1.0.0.1
      host = 1.0.0.1

      ++ L3-1
      menu = Level3 DNS 1
      title = Level3 DNS 4.2.2.1
      host = 4.2.2.1

      ++ L3-2
      menu = Level3 DNS 2
      title = Level3 DNS 4.2.2.2
      host = 4.2.2.2

      ++ Quad9
      menu = Quad9
      title = Quad9 DNS 9.9.9.9
      host = 9.9.9.9
    '';
  };

  services.fcgiwrap = {
    enable = true;
  };

  services.nginx.virtualHosts."${fqdn}" = {
    root = "${pkgs.smokeping}/htdocs";
    extraConfig = ''
      index smokeping.fcgi;
      gzip off;
    '';

    locations."~ \\.fcgi$" = {
      extraConfig = ''
        fastcgi_intercept_errors on;
        include ${pkgs.nginx}/conf/fastcgi_params;
        fastcgi_param SCRIPT_FILENAME ${config.users.users.smokeping.home}/smokeping.fcgi;
        fastcgi_pass unix:/run/fcgiwrap.sock;
      '';
    };

    locations."/cache/" = {
      extraConfig = ''
        alias /var/lib/smokeping/cache/;
        gzip off;
      '';
    };
  };
}
