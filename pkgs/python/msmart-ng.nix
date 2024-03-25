{ stdenv, pkgs, lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "msmart-ng";
  version = "2023.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9g8JFcvotrW0sh+LKqeKYlh1fydnOAYU/VqaCt0balM=";
  };

  doCheck = false;

  pythonImportsCheck = [ "msmart" ];

  meta = with lib; {
    description = "A Python library for local control of Midea (and associated brands) smart air conditioners.";
    homepage = "https://github.com/mill1000/midea-msmart";
    license = licenses.mit;
  };
}