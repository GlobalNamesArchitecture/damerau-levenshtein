{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
        bundlerEnv = pkgs.bundlerEnv;
        mkShell = pkgs.mkShell;

        gems = bundlerEnv {
          name = "gems-for-some-project";
          gemdir = ./.; # Assuming your Gemfile is in the project root
        };
      in {
        devShells.default = mkShell {
          packages = [gems gems.wrappedRuby];
        };
      }
    );
}
