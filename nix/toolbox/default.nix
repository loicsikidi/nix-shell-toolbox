{
  pkgs ? import <nixpkgs> {},
  toolboxConfig ? {},
}: let
  # Default configuration - all tools enabled by default
  defaultConfig = {
    check-workflows = true;
    gotest = true;
    lint = true;
    genproto = true;
  };

  # Merge user config with defaults
  config = defaultConfig // toolboxConfig;

  # All available tools
  allTools = {
    genproto = import ./genproto.nix {inherit pkgs;};
    gotest = import ./gotest.nix {inherit pkgs;};
    lint = import ./lint.nix {inherit pkgs;};
    check-workflows = import ./zizmor.nix {inherit pkgs;};
  };

  # Filter tools based on enabled config
  enabledTools = pkgs.lib.filterAttrs (name: _: config.${name} or false) allTools;
in
  # Return list of enabled derivations for buildInputs
  pkgs.lib.attrValues enabledTools
