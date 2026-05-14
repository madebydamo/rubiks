# Rubiks service options.
{...}: {
  flake.modules.nixos.rubiks-option = {
    config,
    lib,
    ...
  }:
    with lib; {
      options.neo.services.rubiks = mkOption {
        type = types.submodule {
          options =
            {
              enabled = mkEnableOption "Rubiks service";
              port = mkOption {
                type = types.port;
                default = 8123;
                description = "Port for the rubiks nginx server";
              };
            }
            // neo.mkReverseProxyOptions {
              subdomain = "rubiks";
              auth.enabled = false;
            };
        };
        default = {};
        description = "Rubiks cube solver web service configuration";
      };
    };
}
