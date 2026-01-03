{ pkgs, inputs, system, ... }:
let
  pkgs_25_11 = import inputs.nixpkgs-25-11 {
    inherit system;
    config.allowUnfree = true;
  };
  pwndbg-wrapped = pkgs_25_11.writeShellScriptBin "pwndbg" ''
    unset PYTHONPATH
    exec ${inputs.pwndbg.packages."${system}".default}/bin/pwndbg "$@"
  '';
in pkgs_25_11.mkShell {
  packages = with pkgs_25_11; [
    # Because strings is nice
    binutils
    # Because disassemblers are nice
    ghidra-bin
    # Because GDB gets alot better
    pwndbg-wrapped
    # Because sometimes you need to program
    gcc
    # Python with common tools for CTFs
    (python3.withPackages (ps: [ ps.pwntools ps.ropper ]))
    # RE framework
    cutter
    # Single instruction gadget finder for getting shells
    one_gadget
    # CyberChef but in the CLI
    pkgs.internal.chepy
    # For analyzing and extracting firmware
    binwalk
    # For recovering hidden or deleted files
    scalpel
    # Viewing and editing image metadata
    exiftool
    # Network discovery
    nmap

    # As nix doesnt provide all tooling usually needed
    busybox

    # Stag is painful
    stegseek
    steghide
    outguess

    # Because some ctfs like to use mail
    mailutils

    # Bruteforcing
    hashcat
    john

  ];

  shellHook = ''
    echo "CTF development environment loaded"
    echo "Available tools: ghidra, pwndbg, gcc, pwntools, cutter, binwalk, nmap, hashcat, john, and more"
  '';
}
