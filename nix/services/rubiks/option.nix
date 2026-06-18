# Rubiks service options.
{...}: {
  flake.modules.nixos.rubiks-option = {
    config,
    lib,
    ...
  }:
    with lib;
    with {inherit (lib.neo) mkOption mkEnableOption;}; {
      options.neo.services.rubiks = mkOption {
        type = types.submodule {
          options =
            {
              enabled = mkEnableOption "Rubiks service" {rank = 0;};
              port = mkOption {
                type = types.port;
                default = 8123;
                description = "Port for the rubiks nginx server";
                rank = 10;
              };
            }
            // neo.mkReverseProxyOptions {
              subdomain = "rubiks";
              auth.enabled = false;
            }
            // lib.neo.mkServiceMeta {
              icon = "https://upload.wikimedia.org/wikipedia/commons/b/b6/Rubik%27s_cube_v3.svg";
              description = ''
                My fucking rubikscube solver! Enjoy the mesmerizing solves.
                Solves rubiks cubes with the ROUX method
              '';
              projectUrl = "https://rubiks.damo4mf20.ch/";
              githubUrl = "https://github.com/madebydamo/rubiks";
            };
        };
        default = {};
        description = "Rubiks cube solver web service configuration";
      };
    };
}
