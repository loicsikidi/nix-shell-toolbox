{
  pkgs,
  hooksConfig ? {},
  ...
}: let
  nix-pre-commit-hooks = import (
    # Pin to a specific commit to avoid regression introduced by https://github.com/cachix/git-hooks.nix/pull/664
    builtins.fetchTarball "https://github.com/cachix/git-hooks.nix/tarball/50b9238891e388c9fdc6a5c49e49c42533a1b5ce"
  );

  # Default configuration for all hooks
  defaultHooks = {
    # Common hooks
    end-of-file-fixer = {
      enable = true;
    };

    # Nix formatting and linting
    alejandra = {
      enable = true;
    };

    # Golang hooks
    gofmt = {
      enable = true;
    };
    golangci-lint = {
      enable = true;
      package = pkgs.golangci-lint;
      stages = ["pre-push"];
      extraPackages = with pkgs; [go openssl];
    };
    gotest = {
      enable = true;
      package = pkgs.go;
      settings.flags = "";
      stages = ["pre-push"];
      extraPackages = with pkgs; [go openssl gcc];
    };

    # link checker
    lychee = {
      enable = true;
      package = pkgs.lychee;
      settings.flags = "."; # Check all files
      pass_filenames = false;
    };

    # Zizmor hook for GitHub workflow security scanning
    zizmor = {
      enable = true;
      package = pkgs.zizmor;
    };

    # Custom hooks dedicated to tpm-ca-certificates repo
    tpmtb-format = {
      enable = false;
      name = "tpmtb Config Format";
      description = "Check tpmtb Config files formatting";
      files = "^\\.tpm-(roots|intermediates)\\.yaml$";
      entry = "${pkgs.go}/bin/go run ./ config format --dry-run --config";
      language = "system";
      pass_filenames = true;
    };

    tpmtb-validate = {
      enable = false;
      name = "tpmtb Config Validate";
      description = "Validate tpmtb Config files";
      files = "^\\.tpm-(roots|intermediates)\\.yaml$";
      entry = "${pkgs.go}/bin/go run ./ config validate --config";
      language = "system";
      pass_filenames = true;
    };
  };

  # Merge user config with defaults, with user config taking precedence
  mergeHookConfig = hookName: defaultConfig:
    if builtins.hasAttr hookName hooksConfig
    then defaultConfig // hooksConfig.${hookName}
    else defaultConfig;

  # Apply user overrides to all hooks
  finalHooks = builtins.mapAttrs mergeHookConfig defaultHooks;
in
  nix-pre-commit-hooks.run {
    src = ./.;
    hooks = finalHooks;
  }
