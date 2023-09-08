{ pkgs, ... }:
{
  environment.variables = { EDITOR = "vim"; };

  environment.systemPackages = with pkgs; [
    ((vim_configurable.override {  }).customize{
      name = "vim";
      # Install plugins for example for syntax highlighting of nix files
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [
          vim-nix               # syntax for nix files
          vim-lastplace         # open files at last edit
          indentLine            # visible indents
          auto-pairs            # closes brackets
          vim-fugitive          # use :g for Git commands
          vim-gitgutter         # indicates changes from current git branch
          vim-better-whitespace # makes trailing spaces visible
          vim-airline           # status bar at bottom of vim
          gruvbox               # colour scheme
        ];
        opt = [];
      };
      vimrcConfig.customRC = ''
        " Enable filetype plugins
        filetype plugin on
        filetype indent on

        " Remove inane defaults
        set backspace=indent,eol,start

        " Set tab behaviour
	      set expandtab
        set autoindent
        set shiftwidth=2
        set tabstop=2

        " Remove error cues
        set noerrorbells
        set novisualbell

        " Enable pasting over ssh
	      set mouse=

        " Visual cues
        syntax on
        set wrap " Wrap lines
        set number " Line numbers
        let g:indent_guides_enable_on_vim_startup = 1 " Indent guide plugin enable

        " Colour Scheme
        set background=dark
        colorscheme gruvbox

        " Escalate write if opened w/o sudo
        cmap w!! w !sudo tee % > /dev/null %
      '';
    }
  )];
}
