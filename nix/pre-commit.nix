{pkgs, ...}: let
  nix-pre-commit-hooks = import (
    # Pin to a specific commit to avoid regression introduced by https://github.com/cachix/git-hooks.nix/pull/664
    builtins.fetchTarball "https://github.com/cachix/git-hooks.nix/tarball/50b9238891e388c9fdc6a5c49e49c42533a1b5ce"
  );
in
  nix-pre-commit-hooks.run {
    src = ./.;
    hooks = {
      # Common hooks
      end-of-file-fixer.enable = true;

      # Nix formatting and linting
      alejandra.enable = true;

      # Golang hooks
      gofmt.enable = true;
      golangci-lint = {
        enable = true;
        package = pkgs.golangci-lint;
        stages = ["pre-push"];
        extraPackages = with pkgs; [go openssl];
      };
      gotest = {
        enable = true;
        package = pkgs.go;
        stages = ["pre-push"];
        extraPackages = with pkgs; [go openssl gcc];
      };

      # Zizmor hook for GitHub workflow security scanning
      zizmor = {
        enable = true;
        package = pkgs.zizmor;
      };
    };
  }
