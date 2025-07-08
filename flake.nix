{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
    awscli-local-src = {
      url = "github:localstack/awscli-local";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, awscli-local-src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        python = pkgs.python3;

        my-python-package = python.pkgs.buildPythonPackage {
          pname = "awscli-local";
          version = "unstable"; # Or a known version

          src = awscli-local-src;

          format = "setuptools";

          propagatedBuildInputs = with pkgs.python3Packages; [
            boto3
            click
            setuptools
            localstack-client
            #awscli
          ];

          doCheck = false;
        };
      in
      {
        packages.default = my-python-package;
      }
    );
}
