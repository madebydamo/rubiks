{inputs, ...}: {
  flake.modules.nixos.rubiks = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.neo.services.rubiks;
    pkgsDart2 = inputs.nixpkgs-dart2.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    projectRoot = ../../../.;

    combinedSrc = pkgs.stdenv.mkDerivation {
      name = "rubiks-combined-src";
      src = lib.cleanSource projectRoot;
      dontConfigure = true;
      dontBuild = true;
      installPhase = ''
        mkdir -p $out
        cp -r rubiks_web $out/
        cp -r rubiks_core $out/
      '';
    };

    pubCache = pkgs.stdenv.mkDerivation {
      name = "rubiks-pub-cache";
      src = combinedSrc;

      nativeBuildInputs = [
        pkgsDart2.dart
        pkgs.cacert
        pkgs.bash
      ];

      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      outputHash = "sha256-B5U7YmTsnqdpjo2OqdlBq510YIoGLSpBLmHE6qaNkds=";

      buildPhase = ''
        export PUB_CACHE=$out
        export DART_VM_OPTIONS="--root-certs-file=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
        export HOME=$TMPDIR

        cp -r $src work
        chmod -R u+w work
        cd work

        dart --root-certs-file="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" pub get --directory=rubiks_web
      '';
      dontFixup = true;

      installPhase = "true";
    };

    rubiksWeb = pkgs.stdenv.mkDerivation {
      pname = "rubiks-web";
      version = "0.1.0";
      src = combinedSrc;

      nativeBuildInputs = [
        pkgsDart2.dart
        pkgs.dart-sass
      ];

      buildPhase = ''
        export PATH=${lib.makeBinPath [pkgsDart2.dart pkgs.dart-sass]}:$PATH
        export PUB_CACHE=${pubCache}
        export HOME=$TMPDIR

        cp -r $src work
        chmod -R u+w work
        cd work

        dart pub get --offline --directory=rubiks_web

        cd rubiks_web
        dart run build_runner build --release -o build

        rm -f build/web/packages || true
        cd ../..
      '';

      installPhase = ''
        mkdir -p $out
        cp -r work/rubiks_web/build/web/. $out/
      '';
    };
  in {
    config = lib.mkIf cfg.enabled {
      services.nginx = {
        enable = true;
        virtualHosts."rubiks.local" = {
          listen = [
            {
              addr = "0.0.0.0";
              port = cfg.port;
            }
          ];
          root = rubiksWeb;
          locations."/" = {
            tryFiles = "$uri $uri/ /index.html";
          };
        };
      };
    };
  };
}
