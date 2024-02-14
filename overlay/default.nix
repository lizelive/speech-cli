final: prev:
let
  packageOverrides = python-final: python-prev: with python-final; {
    speechrecognition = callPackage ./python/speechrecognition.nix { };
  };

  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [ packageOverrides ];
in
{
  inherit pythonPackagesExtensions;
  opencv = prev.opencv.overrideAttrs (old: {
    doCheck = false;
  });
  # opencv = prev.opencv.override {
  #   enableGtk3 = false;
  #   enableFfmpeg = false;
  #   enableCuda = false;
  #   enableUnfree = false;
  # };
}
