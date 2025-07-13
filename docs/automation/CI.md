# CI Pipelines

We have two GitHub Actions workflows:

1. **GdUnit4 Tests** ([`.github/workflows/gdunit.yml`](../../.github/workflows/gdunit.yml))
   Runs Godot unit tests powered by gdUnit4 on every push.
2. **Godot CI** ([`.github/workflows/godot-ci.yml`](../../.github/workflows/godot-ci.yml))
   Builds & exports the game for Windows, Linux, macOS, Web (HTML5), and deploys to Itch.io & GitHub Pages. Runs only on main branch push.
