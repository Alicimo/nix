{ lib, config, ... }:
with lib;
{
    options.services.globalVars = {
        enable = mkOption {
            default = true;
            type = types.nullOr types.bool;
        };
        domain = mkOption {
            type = types.nullOr types.str;
        };
        dataDir = mkOption {
            type = types.nullOr types.str;
        };
        mediaDir = mkOption {
            type = types.nullOr types.str;
            default = "${config.services.globalVars.dataDir}/media";
        };
        containerDir = mkOption {
            type = types.nullOr types.str;
            default = "${config.services.globalVars.dataDir}/containers";
        };
    };
}
