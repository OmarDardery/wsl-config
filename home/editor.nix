{ ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = false;
    withRuby = false;
    withNodeJs = false;
  };

  # LazyVim config is version-controlled; edit it in this repository.
  xdg.configFile."nvim/init.lua".source = ../nvim/init.lua;
  xdg.configFile."nvim/lua/plugins/tools.lua".source = ../nvim/lua/plugins/tools.lua;
}
