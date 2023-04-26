{  stdenv
 , url
 , version
 , sha256
 , nix-filter
 , fetchurl
 , lib
 , autoPatchelfHook
 , jre
 , makeWrapper
 , wrapGAppsHook
 , gtk3 
 , Cocoa ? null
}:
stdenv.mkDerivation {
  inherit version;
  name = "jmc";
  sourceRoot = "JDK Mission Control";
  src = fetchurl {
    inherit sha256 url;
  };
  nativeBuildInputs = [ autoPatchelfHook makeWrapper ] ++ lib.optionals stdenv.isLinux [ wrapGAppsHook ];
  installPhase = ''
    install -m755 -D jmc $out/bin/jmc
    cp jmc.ini $out/bin/
    cp -r plugins $out/bin/plugins
    cp -r configuration $out/bin/configuration
  '';
  preFixup = ''
    wrapProgram $out/bin/jmc --prefix PATH : "${jre}/bin" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath
        (lib.optionals stdenv.isLinux [ gtk3 ] ++ lib.optionals stdenv.isDarwin [ Cocoa ])}"
  '';
  meta = with lib;
    {
      homepage = "https://github.com/adoptium/jmc-build";
      license = licenses.unlicense;
    };
}
