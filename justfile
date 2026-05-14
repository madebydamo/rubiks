set dotenv-load := false

default:
  @just --list

# Launch the website on localhost (live dev server)
launch:
  cd rubiks_web && dart pub get && dart run build_runner serve

# Run tests for rubiks_core
test:
  cd rubiks_core && dart pub get && dart test test/rubiks_core_test.dart test/model/test_cube.dart test/solver/test_solver.dart --reporter=compact

# Run the rubiks_core_example.dart
generate:
  cd rubiks_core && dart pub get && dart run example/rubiks_core_example.dart

# Deploy web app to gh-pages using peanut
deploy:
  cd rubiks_web && dart pub get && dart run peanut
