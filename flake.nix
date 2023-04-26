{
  description = "JMC (JDK Mission Control)";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-22.11;
    flake-utils.url = github:numtide/flake-utils;
    nix-filter.url = github:numtide/nix-filter; 
  };

  outputs = { self, nixpkgs, flake-utils, nix-filter }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        version = "8.3.0";
        sha256 = "sha256-CkN9/8xenVYSyBxJswdw93NY5fLvAgH7qsgmv+yg/40=";
        jmc = pkgs.callPackage (import ./default.nix) {
          inherit version sha256 nix-filter;
        };
      in {
        packages = rec {
          inherit jmc;
          default = jmc;
        };
      }
    );
}
