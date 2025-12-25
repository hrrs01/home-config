{ pkgs, inputs, system, ... }:
let
  pkgs_25_11 = import inputs.nixpkgs-25-11 {
    inherit system;
    config.allowUnfree = true;
  };
in
pkgs_25_11.mkShell {
  packages = with pkgs_25_11; [
    # Because strings is nice
    binutils
    # Because disassemblers are nice
    ghidra-bin
    # Because GDB gets alot better
    inputs.pwndbg.packages."${system}".default
    # Because sometimes you need to program
    gcc
    # Python with common tools for CTFs
    (python3.withPackages (ps: [ ps.pwntools ps.ropper ]))
    # RE framework
    cutter
    # Single instruction gadget finder for getting shells
    one_gadget
    # For analyzing and extracting firmware
    binwalk
    # For recovering hidden or deleted files
    scalpel
    # Viewing and editing image metadata
    exiftool
    # Network discovery
    nmap

    # Bruteforcing
    hashcat
    john

  ];

  shellHook = ''
    echo "CTF development environment loaded"
    echo "Available tools: ghidra, pwndbg, gcc, pwntools, cutter, binwalk, nmap, hashcat, john, and more"
  '';
}
