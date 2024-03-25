{ stdenv, pkgs, fetchFromGitHub, buildHomeAssistantComponent, plugp100 }:

buildHomeAssistantComponent  rec {

  owner = "petretiandrea";
  domain = "tapo";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "petretiandrea";
    repo = "home-assistant-tapo-p100";
    rev = "v${version}";
    sha256 = "sha256-RCZte/US7LWYUmv8GZKBDK7qcfmitQCdDrdr1BxKZ/g=";
  };

  propagatedBuildInputs = [
    plugp100
    pkgs.python311Packages.jsons
    pkgs.python311Packages.semantic-version
  ];

}