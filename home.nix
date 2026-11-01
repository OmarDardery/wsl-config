{ pkgs, ... }:
{
  imports = [
    ./home/shell.nix
    ./home/git.nix
    ./home/editor.nix
  ];

  home.username = "oad";
  home.homeDirectory = "/home/oad";
  home.stateVersion = "26.05";

  # Small everyday toolset; project-specific dependencies belong in devShells.
  home.packages = with pkgs; [
    # Go backends (Gin, GORM, PostgreSQL, etc.)
    go
    gopls
    gofumpt

    # Git/CLI and terminal utilities
    jq
    ripgrep
    fd
    bat
    eza
    curl
    unzip
    zip
    btop
    tmux
    delta

    # Nix editing
    nixd
    nixfmt
  ];

  programs.home-manager.enable = true;

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings.mgr = {
      sort_by = "natural";
      sort_dir_first = true;
      show_hidden = false;
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
