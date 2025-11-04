{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    shellAliases = {
      df = "duf";
      diff = "delta";
      du = "dust";
      htop = "btm";
      top = "btm";
      ls = "eza --group-directories-first --icons";
      man = "tldr";
      tree = "tre";
      grep = "rg";
    };
    functions = { 
      cl = {
        description = "cd and ls into dir";
        body = ''
          cd $argv; or return 1
          eza --icons
        '';
      };

      less = { 
        wraps = "bat";
        description = "pick a pager";
        body = ''
          set file $argv[1]
          if string match -r '.*\.(md|markdown)$' -- $file
              glow -p $argv
          else if string match -r '.*\.(json)$' -- $file
              jless $argv
          else
              bat $argv
          end
        '';
      };

      fkill = {
        body = ''
          set -l procs (ps -eo pid,user,pcpu,pmem,etime,comm --sort=-pcpu | sed 1d)
          set -l lines (
          echo $procs | tr " " "\n" | paste - - - - - - \
          | fzf --multi --reverse \
              --header="Tab to multi-select; Enter to kill (default SIGTERM)" \
              --prompt="PROC> " \
              --preview 'echo {}' \
          )
          test -n "$lines"; or return

          # Extract the first column (PID); handles multiple selections
          set -l pids (printf "%s\n" $lines | awk '{print $1}')
          test -n "$pids"; and command kill $argv $pids
        '';
        wraps = "kill";
      };

      kill = {
        wraps = "kill";
        body = ''
          if test (count $argv) -gt 0
            command kill $argv
          else
            fkill
          end
        '';
      };
    };
    plugins = [
      {
        name = "bobthefish";
        src = pkgs.fishPlugins.bobthefish;
      }
    ];
    interactiveShellInit = ''
      set -g theme_powerline_fonts yes
    '';
  };

  xdg.configFile."fish/conf.d/99-bobthefish.fish".text = ''
    set -l bob "${pkgs.fishPlugins.bobthefish}"
    set -g fish_function_path "$bob/share/fish/vendor_functions.d" $fish_function_path
    for f in "$bob/share/fish/vendor_conf.d"/*.fish
        source $f
    end
  '';

}

