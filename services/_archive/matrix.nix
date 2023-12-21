{ pkgs, lib, config, ... }:
{
  services.postgresql = {
    enable = true;
    initialScript = pkgs.writeText "synapse-init.sql" ''
      CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
      CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
        TEMPLATE template0
        LC_COLLATE = "C"
        LC_CTYPE = "C";
      '';
  };

  services.nginx.virtualHosts = {
#    "${config.networking.domain}" = {
#      locations."= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
#      locations."= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
#    }
    "matrix.${config.networking.fqdn}".locations = {
      "/".extraConfig = ''
        return 404;
      '';
      "/_matrix".proxyPass = "http://[::1]:8008";
      "/_synapse/client".proxyPass = "http://[::1]:8008";
    };
    "chat.${config.networking.fqdn}" = {
      root = pkgs.element-web.override {
        conf.default_server_config = {
          "m.homeserver".base_url = "http://matrix.${config.networking.fqdn}";
        };
      };
    };
  };

  services.matrix-synapse = {
    enable = true;
    settings = {
      enable_registration = true;
      enable_registration_without_verification = true;
      registration_shared_secret = "password";
      server_name = "${config.networking.fqdn}";
      listeners = [
        {
          port = 8008;
          bind_addresses = [ "::1" ];
          tls = false;
          type = "http";
          x_forwarded = true;
          resources = [
            {
              names = [ "client" "federation" ];
              compress = true;
            }
          ];
        }
      ];
    };
  };
}

