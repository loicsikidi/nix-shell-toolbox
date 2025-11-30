{ pkgs }:

pkgs.writeShellApplication {
  name = "check-workflows";
  runtimeInputs = [ pkgs.zizmor ];
  text = ''
    if ! zizmor .github/workflows/; then
      echo "workflow security issues found ⛔"
      exit 1
    fi
    echo "no workflow security issues found 💫"
  '';
}
