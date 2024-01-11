final: prev:
let
  packageOverrides = python-final: python-prev: with python-final; {
    speechrecognition = callPackage ./python/speechrecognition.nix { };
  };

  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [ packageOverrides ];
in
{ inherit pythonPackagesExtensions; }
