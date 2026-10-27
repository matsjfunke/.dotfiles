{ lib, stdenvNoCC, makeWrapper, python312 }:

stdenvNoCC.mkDerivation {
  pname = "mac-cleanup";
  version = "1.0.0";
  src = lib.cleanSource ./.;
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    runHook preInstall
    mkdir -p "$out/libexec/mac-cleanup" "$out/bin"
    cp mac_cleanup.py bazel_cache_cleanup.py "$out/libexec/mac-cleanup/"
    makeWrapper ${python312}/bin/python3 "$out/bin/mac-cleanup" \
      --add-flags "-u $out/libexec/mac-cleanup/mac_cleanup.py"
    runHook postInstall
  '';
  meta = {
    description = "Deterministic personal-file, abandoned Bazel output, and Homebrew cleanup";
    platforms = lib.platforms.darwin;
    mainProgram = "mac-cleanup";
  };
}
