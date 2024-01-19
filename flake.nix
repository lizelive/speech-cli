
{
  description = "Flake utils demo";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

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
        python3Packages = pkgs.python3Packages;
        pickPythonPackage = pkgs.lib.attrsets.attrVals pyproject.project.dependencies;
        dependencies = pickPythonPackage python3Packages;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            (pkgs.python3.withPackages pickPythonPackage)
          ];
        };
        packages.default =
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
