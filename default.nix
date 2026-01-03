{
  pkgs ? import <nixpkgs> {},
  toolboxConfig ? {},
  hooksConfig ? {},
}: let
  toolbox = import ./nix/toolbox {inherit pkgs toolboxConfig;};
  pre-commit = import ./nix/pre-commit.nix {inherit pkgs hooksConfig;};
  commonPackages =
    toolbox
    ++ pre-commit.enabledPackages
    ++ [
      pkgs.delve
    ];
in {
  # All packages (toolbox + pre-commit)
  # Use this for buildInputs to get everything
  packages = commonPackages;

  # Pre-commit shellHook
  # Use this in mkShell's shellHook
  shellHook = pre-commit.shellHook;
}
