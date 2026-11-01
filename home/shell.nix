{ ... }:
{
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      share = true;
    };

    shellAliases = {
      ls = "eza --icons=auto --group-directories-first";
      ll = "eza -lh --icons=auto --group-directories-first";
      la = "eza -lah --icons=auto --group-directories-first";
      lt = "eza --tree --level=2";
      cat = "bat --paging=never";
      vi = "nvim";
      vim = "nvim";
      lg = "lazygit";
      cconf = "cd ~/wsl-config";
      cnf = "nvim ~/wsl-config";
      up = "sudo nixos-rebuild switch --flake \"path:$HOME/wsl-config#wsl\"";
      nbuild = "nixos-rebuild build --flake \"path:$HOME/wsl-config#wsl\"";
      nupdate = "nix flake update --flake \"path:$HOME/wsl-config\"";
      win = "explorer.exe .";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      command_timeout = 1000;
    };
  };
}
