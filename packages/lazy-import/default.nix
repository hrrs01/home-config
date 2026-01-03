{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonPackage rec {
  pname = "lazy-import";
  version = "0.2.2";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "lazy_import";
    hash = "sha256-IUmu+FeUWUB8Ys/szxGFJ5OcmTGs4STzVSNjYGRPij0=";
  };

  doCheck = false;

  meta = with lib; {
    description =
      "lazy-import provides a set of functions that load modules, and related attributes, in a lazy fashion";
    homepage = "https://github.com/mnmelo/lazy_import";
    license = licenses.gpl3;
  };
}
