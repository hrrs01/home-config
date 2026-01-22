{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "obsidian-cli";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "Yakitrak";
    repo = "obsidian-cli";
    rev = "v${version}";
    hash = "sha256-Fqe3GJgVovBdy6gFPmDQ7jMIoSb1XgSsDW6zacxNRJc=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Interact with Obsidian in the terminal. Open, search, create, update, move, delete and print notes";
    homepage = "https://github.com/Yakitrak/obsidian-cli";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "obsidian-cli";
  };
}
