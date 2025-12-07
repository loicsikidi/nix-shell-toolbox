{
  pkgs ? import <nixpkgs> {},
  toolboxConfig ? {},
  hooksConfig ? {},
}: let
  toolbox = import ./nix/toolbox {inherit pkgs toolboxConfig;};
  pre-commit = import ./nix/pre-commit.nix {inherit pkgs hooksConfig;};
in {
  # All packages (toolbox + pre-commit)
  # Use this for buildInputs to get everything
  packages = toolbox ++ pre-commit.enabledPackages;

  # Pre-commit shellHook
  # Use this in mkShell's shellHook
  shellHook = pre-commit.shellHook;
}
