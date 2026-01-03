{ lib, python3Packages, fetchPypi, pkgs }:

python3Packages.buildPythonPackage rec {
  pname = "chepy";
  version = "7.0.0"; # Check PyPI for latest version
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash =
      "sha256-IpXWgKmRam8AKqZmnQuq1BD7dAzCJzFQaPsEQ1rie2k="; # Replace with real hash
  };

  propagatedBuildInputs = with python3Packages; [
    colorama
    emoji
    exrex
    decorator
    base58
    jsonpickle
    pycryptodome
    crccheck
    fire
    hexdump
    jmespath
    lz4
    parsel
    passlib
    pgpy
    prompt-toolkit
    pkgs.internal.pycipher
    pretty-errors
    docstring-parser
    six
    pyjwt
    pkgs.internal.lazy-import
    pyopenssl
    regex
    pyperclip
    pyyaml
    pydash
    typing-extensions
    msgpack
    pyopenssl
    requests
    termcolor
  ];

  # Tests may require network or additional dependencies
  doCheck = false;

  meta = with lib; {
    description =
      "Chepy is a python lib/cli equivalent of the awesome CyberChef tool";
    homepage = "https://github.com/securisec/chepy";
    license = licenses.gpl3Only;
    maintainers = [ ];
  };
}
