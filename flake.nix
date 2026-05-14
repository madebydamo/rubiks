{
  description = "Rubiks cube solver - Dart core + web";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # === Add this for Dart < 3.0 ===
    nixpkgs-dart2.url = "github:NixOS/nixpkgs/1b7a6a6e57661d7d4e0775658930059b77ce94a4"; # e.g. 1b7a6a6e57661d7d4e0775658930059b77ce94a4

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-dart2,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        pkgsDart2 = nixpkgs-dart2.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            pkgsDart2.dart
            just
            git
            python3
          ];

          # Optional: helpful environment variables
          shellHook = ''
            echo "Using Dart: $(dart --version)"
            zsh
          '';
        };
      }
    );
}
