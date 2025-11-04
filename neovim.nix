{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Nix-managed plugin set
    plugins = with pkgs.vimPlugins; [
      tagalong-vim
      vim-closetag
      telescope-nvim
      plenary-nvim
      which-key-nvim
      nvim-surround
      comment-nvim
      gitsigns-nvim
      nvim-autopairs
      lualine-nvim
      nvim-web-devicons
      nvim-tree-lua
      leap-nvim
      catppuccin-nvim
      nvim-scrollbar
      nvim-hlslens
    ];

    # Point Neovim at the single-file config
    extraLuaConfig = builtins.readFile ./nvim/init-nix-nvim.lua;
  };

  # Additional tools needed by neovim plugins
  home.packages = with pkgs; [
    ripgrep  # for telescope live_grep
    fd       # for telescope find_files
  ];
}

