
{
  description = "Flake utils demo";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        src = ./.;
        pyproject = builtins.fromTOML (builtins.readFile ./pyproject.toml);
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (import ./overlay)
          ];
          config = { };
        };
      in
      {
        packages.default =
          let
            python3Packages = pkgs.python3Packages;
            dependencies = pkgs.lib.attrsets.attrVals pyproject.project.dependencies python3Packages;
          in
          python3Packages.buildPythonApplication {
            inherit (pyproject.project) name;
            inherit src;
            format = "pyproject";
            propagatedBuildInputs = dependencies;
            nativeBuildInputs = [ python3Packages.setuptools ];
          };
      }
    );
}
