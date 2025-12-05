{pkgs, ...}: let
  nix-pre-commit-hooks = import (
    builtins.fetchTarball "https://github.com/cachix/git-hooks.nix/tarball/master"
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
