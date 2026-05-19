{
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [ inputs.coding-agents.homeManagerModules.default ];

  nixpkgs.overlays = [ inputs.coding-agents.overlays.default ];

  coding-agents = {
    pi-coding-agent.enable = true;
    # claude-code.enable = true;   # if you want these too
    # codex.enable = true;
  };
}
