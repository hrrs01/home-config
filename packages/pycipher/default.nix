{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonPackage rec {
  pname = "pycipher";
  version = "0.5.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash =
      "sha256-5bOz73NGBNoJ4WQvnElqdd+FBmiu5bGIGKOYjuxM1xs="; # Replace with real hash
  };

  doCheck = false;

  meta = with lib; {
    description = "Common classical ciphers implemented in Python";
    homepage = "https://github.com/jameslyons/pycipher";
    license = licenses.mit;
  };
}
