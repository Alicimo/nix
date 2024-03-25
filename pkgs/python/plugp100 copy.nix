{ stdenv
, pkgs
, lib
, python3
, fetchPypi }:

let
  defaultOverrides = [
    (self: super: {
      urllib3 = super.urllib3.overridePythonAttrs (oldAttrs: rec {
        pname = "urllib3";
        version = "1.26.18";
        src = fetchPypi {
          inherit pname version;
          hash = "sha256-+OzBu6VmdBNFfFKauVW/jGe0XbeZ0VkGYmFxnjKFgKA=";
        };
        nativeBuildInputs = with self; [
          setuptools
        ];
      });
    })
  ];
  
  python = python3.override {
    packageOverrides = lib.composeManyExtensions (defaultOverrides);
  };

in python.pkgs.buildPythonPackage rec {
  pname = "plugp100";
  version = "4.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zeK1ij3F6Ot+EBrXvHzoyGgJFEesTrzjksQP9N4Y4IM=";
  };

  doCheck = false;

  pythonImportsCheck = [ "plugp100" ];

  propagatedBuildInputs = with python.pkgs; [
    urllib3
  ];

}