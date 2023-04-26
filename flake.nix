{
  description = "JMC (JDK Mission Control)";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-22.11;
    flake-utils.url = github:numtide/flake-utils;
    nix-filter.url = github:numtide/nix-filter;
    flake-compat = {
      url = github:edolstra/flake-compat;
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, nix-filter, ... }:
    let
      platforms = {
        x86_64-linux = {
          hash = "sha256-CkN9/8xenVYSyBxJswdw93NY5fLvAgH7qsgmv+yg/40=";
          prefix = "linux.gtk.x86_64";
        };
        x86_64-darwin = {
          prefix = "macos.cocoa.x86_64";
          hash = "sha256-0z51jm7a6wm9zmq66g6m72r3lb2yvifp5ff7p58cbilnal3fkd87";
        };
      };
    in flake-utils.lib.eachSystem (builtins.attrNames platforms) (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        version = "8.3.0";
        platform = platforms.${system};
        url = "https://github.com/adoptium/jmc-build/releases/download/${version}/org.openjdk.jmc-${version}-${platform.prefix}.tar.gz";
        sha256 = platform.hash;
        jmc = pkgs.callPackage (import ./generic.nix) {
          inherit version sha256 nix-filter url;
        };
      in {
        packages = rec {
          inherit jmc;
          default = jmc;
        };
      }
    );
}
