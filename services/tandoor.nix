{ config, ... }:
{
  services.tandoor-recipes = {
    enable = true;
    port = 2534;
  };
  services.nginx.virtualHosts."food.${config.networking.fqdn}" = {
    locations."/".proxyPass = "http://127.0.0.1:${toString config.services.tandoor-recipes.port}";
  };
}
