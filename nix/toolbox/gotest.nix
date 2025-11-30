{ pkgs }:

pkgs.writeShellApplication {
  name = "gotest";
  runtimeInputs = [ pkgs.go ];
  text = ''
    mapfile -t paths < <(go list ./... | grep -vE '/proto') # exclude generated code
    if ! go test -short=true -count=1 -failfast -covermode=count -coverprofile=coverage.out -v "''${paths[@]}"; then
      echo "tests failed ⛔"
      exit 1
    fi
    rm -f coverage.out
    echo "all tests passed 💫"
  '';
}
