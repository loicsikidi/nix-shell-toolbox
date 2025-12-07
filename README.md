# Nix Shell Toolbox

Reusable Nix helpers for development environments and CI/CD.

## Disclaimer

This repository is primarily for my personal use. While you're welcome to use it, I take no responsibility for issues caused by this code. Use at your own risk.

## Usage

### Standard Import (Recommended)

Uses latest main branch. Backward compatibility is guaranteed.

```nix
let
  helpers = import (
    builtins.fetchTarball "https://github.com/loicsikidi/nix-shell-toolbox/tarball/main"
  ) {
    inherit pkgs;
    toolboxConfig = {
      check-workflows = false;
    };
  };
in
pkgs.mkShell {
  buildInputs = [ pkgs.go pkgs.syft ] ++ helpers.packages;
  shellHook = helpers.shellHook;
}
```

> [!TIP]
> `builtins.fetchTarball` caches tarballs in `~/.cache/nix/tarballs/`.
> If your local nix-shell doesn't detect remote changes, force refresh with: `rm -rf ~/.cache/nix/tarballs/`

### Pinned Import (Critical Projects)

For projects requiring something stable, pin to a specific release.

```nix
let
  helpers = import (builtins.fetchGit {
    url = "https://github.com/loicsikidi/nix-shell-toolbox";
    ref = "v1.0.0";
    rev = "abc123...";
  }) { inherit pkgs; };
in
pkgs.mkShell {
  buildInputs = [ pkgs.go ] ++ helpers.packages;
  shellHook = helpers.shellHook;
}
```

### Available Tools

All tools are enabled by default:

- `gotest` - Run Go tests with coverage
- `lint` - Run golangci-lint
- `check-workflows` - Scan GitHub Actions with zizmor

## Configuration

### Disabling Tools

Use the `toolboxConfig` parameter to disable specific toolbox commands:

```nix
let
  helpers = import (
    builtins.fetchTarball "https://github.com/loicsikidi/nix-shell-toolbox/tarball/main"
  ) {
    inherit pkgs;
    toolboxConfig = {
      check-workflows = false;
    };
  };
in
pkgs.mkShell {
  buildInputs = [ pkgs.go ] ++ helpers.packages;
  shellHook = helpers.shellHook;
}
```

### Customizing Pre-commit Hooks

Use the `hooksConfig` parameter to customize or disable pre-commit hooks:

```nix
let
  helpers = import (
    builtins.fetchTarball "https://github.com/loicsikidi/nix-shell-toolbox/tarball/main"
  ) {
    inherit pkgs;
    hooksConfig = {
      # Disable specific hooks
      gofmt.enable = false;
      zizmor.enable = false;

      # Add custom flags to gotest
      gotest.settings.flags = "-tags integration -short";

      # Change golangci-lint stage
      golangci-lint.stages = ["pre-commit"];
    };
  };
in
pkgs.mkShell {
  buildInputs = [ pkgs.go ] ++ helpers.packages;
  shellHook = helpers.shellHook;
}
```

### Pre-commit Hooks

> [!NOTE]
> Pre-push hooks are deferred due to execution time

Available hooks to configure via `hooksConfig`:

| Hook | Stage | Description |
|------|-------|-------------|
| end-of-file-fixer | pre-commit | Ensures files end with newline |
| alejandra | pre-commit | Format Nix files |
| gofmt | pre-commit | Format Go code |
| golangci-lint | **pre-push** | Lint Go code |
| gotest | **pre-push** | Run Go tests |
| zizmor | pre-commit | Scan GitHub Actions workflows |
