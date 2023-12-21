{ fetchFromGitHub
, fetchYarnDeps
, makeWrapper
, nodejs-16_x
, yarn2nix-moretea
, ...
}:

let
  version = "5.2.5";
  src = fetchFromGitHub {
    owner = "librespeed";
    repo = "speedtest";
    rev = version;
    sha256 = "";
  };
  nodejs = nodejs-16_x;
  yarn2nix = yarn2nix-moretea.override {
    inherit nodejs;
    inherit (nodejs.pkgs) yarn;
  };
in
yarn2nix.mkYarnPackage {
  pname = "librespeed";
  }
