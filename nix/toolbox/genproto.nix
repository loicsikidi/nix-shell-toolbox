{pkgs}:
pkgs.writeShellApplication {
  name = "genproto";
  runtimeInputs = [pkgs.buf];
  text = ''
    TEMPLATE=buf-go.gen.yaml
    while [[ $# -gt 0 ]]; do
      case $1 in
        --template)
          TEMPLATE=$2
          shift
          ;;
        *)
          echo "Unknown option: $1"
          echo "Usage: genproto [--template path]"
          exit 1
          ;;
      esac
    done

    buf generate --template "${TEMPLATE}" .
    if [ $? -ne 0 ]; then
       echo "proto generate failed ⛔"
       exit 1
    fi
    echo "proto generate succeeded 💫"
  '';
}
