{inputs, ...}: {
  perSystem = {system, pkgs, ...}: let
    pkgsDart2 = inputs.nixpkgs-dart2.legacyPackages.${system};
  in {
    devShells.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        pkgsDart2.dart
        just
        git
        python3
      ];

      shellHook = ''
        echo "Using Dart: $(dart --version)"
        zsh
      '';
    };
  };
}
