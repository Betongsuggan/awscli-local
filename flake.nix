{
  description = "awscli-local (awslocal) packaged for Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    awscli-local-src = {
      url = "github:localstack/awscli-local";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      awscli-local-src,
    }:
    let
      forAllSystems =
        f:
        nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (
          system: f nixpkgs.legacyPackages.${system}
        );
      package = pkgs: pkgs.callPackage ./package.nix { src = awscli-local-src; };
    in
    {
      overlays.default = final: _: { awscli-local = package final; };

      packages = forAllSystems (pkgs: {
        default = package pkgs;
      });

      checks = forAllSystems (pkgs: {
        default = self.packages.${pkgs.stdenv.hostPlatform.system}.default;
      });

      formatter = forAllSystems (pkgs: pkgs.nixfmt);
    };
}
