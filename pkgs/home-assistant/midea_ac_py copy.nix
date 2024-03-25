{ stdenv, pkgs, fetchFromGitHub, buildHomeAssistantComponent, msmart-ng }:

buildHomeAssistantComponent  rec {

  owner = "mill1000";
  domain = "midea_ac";
  version = "2024.1.0";

  src = fetchFromGitHub {
    owner = "mill1000";
    repo = "midea-ac-py";
    rev = version;
    sha256 = "sha256-Vxf/5S6Ek1QRuGOoaeJKS1Ivn902E6hiBvd5oebf5ws=";
  };

  propagatedBuildInputs = [
    msmart-ng
  ];

}