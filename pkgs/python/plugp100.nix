{ stdenv, pkgs, lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "plugp100";
  version = "4.0.3";

  src = fetchFromGitHub {
    owner = "Alicimo";
    repo = "plugp100";
    rev = "v4.0.3";
    sha256 = "sha256-6bdDKWWkUj6AZaCUXfNXG2+deSvYoXnB4AcZbkUORPk=";
  };

  doCheck = false;

  pythonImportsCheck = [ "plugp100" ];

}