# Rubik's Cube Solver

Automatic Rubik's cube solver using the Roux method. Scrambling applies 30 random turns; solving restores the cube to solved state. Interactive cube supports key turns: `L R U D F B M E S X Y Z` (see [cube notation](https://jperm.net/3x3/moves)).

Try it live: [https://madebydamo.github.io/rubiks/](https://madebydamo.github.io/rubiks/)

Compatible plugin for [neo](https://github.com/madebydamo/neo).

## Quick Start (with Nix)

This project uses Nix flakes for reproducible setup.

```bash
nix develop          # enter dev shell (Dart + just + tools)
just                 # list available commands
just launch          # start local dev server at http://localhost:8080
```

## Available Commands

| Command         | Description                                     |
| --------------- | ----------------------------------------------- |
| `just launch`   | Launch web dev server (live reload)             |
| `just test`     | Run all tests in `rubiks_core`                  |
| `just generate` | Run core example to generate precalculated maps |
| `just deploy`   | Deploy web app to GitHub Pages via peanut       |

## Investigation

Core logic lives in [rubiks_core](./rubiks_core). Entry point: [rubiks_core/lib/src/solver/method.dart](./rubiks_core/lib/src/solver/method.dart) (defines `roux2` solver stages). Generate precalculated maps via `just generate` (see [rubiks_core/example/rubiks_core_example.dart](./rubiks_core/example/rubiks_core_example.dart)).

Web UI is in [rubiks_web](./rubiks_web).
