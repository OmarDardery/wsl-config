{ pkgs, ... }:
{
  networking.hostName = "nixos-wsl";
  time.timeZone = "Africa/Cairo";

  wsl = {
    enable = true;
    defaultUser = "oad";
    startMenuLaunchers = false;

    # Preserve normal access to Windows programs and /mnt/c.
    interop.includePath = true;
    wslConf.automount.root = "/mnt";
    wslConf.interop.appendWindowsPath = true;
  };

  # NixOS-WSL creates the normal user and wheel membership.
  programs.zsh.enable = true;
  users.users.oad.shell = pkgs.zsh;

  # Helpful for Windows-side VS Code/VSCodium remote servers and other
  # dynamically linked executables not built with Nix.
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    git
    wget
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # This is the first intended NixOS-WSL release for this installation.
  # Keep the actual installed system's stateVersion on upgrades.
  system.stateVersion = "26.05";
}
