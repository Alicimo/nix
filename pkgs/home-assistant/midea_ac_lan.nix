{ stdenv, pkgs, fetchFromGitHub, buildHomeAssistantComponent }:

buildHomeAssistantComponent  rec {

  owner = "georgezhao2010";
  domain = "midea_ac_lan";
  version = "0.3.22";

  src = fetchFromGitHub {
    owner = "georgezhao2010";
    repo = "midea_ac_lan";
    rev = "v${version}";
    sha256 = "sha256-xTnbA4GztHOE61QObEJbzUSdbuSrhbcJ280DUDdM+n4=";
  };

}