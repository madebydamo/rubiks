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

# Generate JS assets and push to origin/gh_deploy
deploy:
  cd rubiks_web && dart pub get && dart run build_runner build --release
  rm -rf /tmp/gh_deploy
  mkdir -p /tmp/gh_deploy
  cp -r rubiks_web/build/web/* /tmp/gh_deploy/
  git fetch origin gh_deploy || true
  git worktree add --force /tmp/gh_deploy-worktree origin/gh_deploy || git worktree add --force /tmp/gh_deploy-worktree gh_deploy || true
  rm -rf /tmp/gh_deploy-worktree/*
  cp -r /tmp/gh_deploy/* /tmp/gh_deploy-worktree/
  cd /tmp/gh_deploy-worktree && git add -A && git commit -m "Deploy: $(date -u +%Y-%m-%dT%H:%M:%SZ)" || true
  git push origin gh_deploy || true
  git worktree remove /tmp/gh_deploy-worktree || true
