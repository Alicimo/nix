{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    searxng
  ];

  services.searx = {
    enable = true;
    package = pkgs.searxng;
    settings = {
      server = {
        port = 8888;
        secret_key = "secret_key";
      };
    };
  };

#  services.nginx.virtualHosts."search.${config.networking.fqdn}".locations."/".proxyPass = "http://127.0.0.1:${toString config.services.searx.settings.server.port}";
}
