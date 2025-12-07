{pkgs}:
pkgs.writeShellApplication {
  name = "gotest";
  runtimeInputs = [pkgs.go];
  text = ''
    SHORT=false
    RACE=false
    while [[ $# -gt 0 ]]; do
      case $1 in
        --short)
          SHORT=true
          shift
          ;;
        --race)
          RACE=true
          shift
          ;;
        *)
          echo "Unknown option: $1"
          echo "Usage: gotest [--short] [--race]"
          exit 1
          ;;
      esac
    done

    mapfile -t paths < <(go list ./... | grep -vE '/proto') # exclude generated code

    if [ "$SHORT" = true ]; then
      SHORT_FLAG="-short=true"
    else
      SHORT_FLAG="-short=false"
    fi

    if [ "$RACE" = true ]; then
      RACE_FLAG="-race"
    else
      RACE_FLAG=""
    fi

    if ! go test $SHORT_FLAG $RACE_FLAG -count=1 -failfast -covermode=count -coverprofile=coverage.out -v "''${paths[@]}"; then
      echo "tests failed ⛔"
      exit 1
    fi
    rm -f coverage.out
    echo "all tests passed 💫"
  '';
}
