# Nix Shell Toolbox

Reusable Nix helpers for development environments and CI/CD.

## Usage

### Standard Import (Recommended)

Uses latest main branch. Backward compatibility is guaranteed.

```nix
let
  helpers = import (
    builtins.fetchTarball "https://github.com/loicsikidi/nix-shell-toolbox/tarball/main"
  ) {
    inherit pkgs;
    enabled = {
      check-workflows = false;
    };
  };
in
pkgs.mkShell {
  buildInputs = [ pkgs.go pkgs.syft ] ++ helpers.packages;
  shellHook = helpers.shellHook;
}
```

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

### Pre-commit Hooks

| Hook | Stage | Description |
|------|-------|-------------|
| end-of-file-fixer | pre-commit | Ensures files end with newline |
| nixfmt-classic | pre-commit | Format Nix files |
| gofmt | pre-commit | Format Go code |
| golangci-lint | pre-push* | Lint Go code |
| gotest | pre-push* | Run Go tests |
| zizmor | pre-commit | Scan GitHub Actions workflows |

> [!NOTE]
> Pre-push hooks are deferred due to execution time

## Complete Example

```nix
let
  nixpkgs = builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs";
    rev = "057f9aecfb71c4437d2b27d3323df7f93c010b7e";
    ref = "nixos-23.11";
  };
  pkgs = import nixpkgs { };

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
