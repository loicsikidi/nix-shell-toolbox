{ pkgs }:

pkgs.writeShellApplication {
  name = "lint";
  runtimeInputs = [ pkgs.golangci-lint ];
  text = ''
    if ! golangci-lint run ./...; then
      echo "linting issues found ⛔"
      exit 1
    fi
    echo "no linting issues found 💫"
  '';
}
