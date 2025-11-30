{ pkgs ? import <nixpkgs> { }, enabled ? { } }:

let
  # Default configuration - all tools enabled by default
  defaultEnabled = {
    gotest = true;
    lint = true;
    check-workflows = true;
  };

  # Merge user config with defaults
  config = defaultEnabled // enabled;

  # All available tools
  allTools = {
    gotest = import ./gotest.nix { inherit pkgs; };
    lint = import ./lint.nix { inherit pkgs; };
    check-workflows = import ./zizmor.nix { inherit pkgs; };
  };

  # Filter tools based on enabled config
  enabledTools = pkgs.lib.filterAttrs (name: _: config.${name} or false) allTools;

in
# Return list of enabled derivations for buildInputs
pkgs.lib.attrValues enabledTools
