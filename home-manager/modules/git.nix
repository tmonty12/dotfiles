{ config, pkgs, lib, useForwardedSshAgent ? false, ... }:

{
  programs.git = {
    enable = true;
    
    # User information
    userName = "Thomas Montfort";
    userEmail = "tjmontfort12@gmail.com";
    
    # Core settings
    extraConfig = {
      core = {
        editor = "vim";
        fsmonitor = true;
        untrackedCache = true;
      };
      
      init = {
        defaultBranch = "main";
      };
      
      pull = {
        rebase = true;
      };

      rebase = {
        autoStash = true;
      };
      
      push = {
        default = "simple";
      };

      commit.gpgsign = true;
      gpg = {
        format = "ssh";
      } // lib.optionalAttrs useForwardedSshAgent {
        ssh.defaultKeyCommand = "${config.home.homeDirectory}/.local/bin/git-ssh-default-key-command";
        ssh.program = "${config.home.homeDirectory}/.local/bin/git-ssh-keygen";
      };
      
      url = {
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
      };
    } // lib.optionalAttrs (!useForwardedSshAgent) {
      user.signingkey = "~/.ssh/id_rsa.pub";
    };
    
    # Basic ignore patterns
    ignores = [
      ".DS_Store"
      "*.swp"
      "*~"
      ".env"
      "node_modules/"
      "__pycache__/"
      "*.pyc"
    ];
  };

  programs.git.delta = {
    enable = true;  # Better git diffs
    options = {
      navigate = true;
      line-numbers = true;
      side-by-side = true;
    };
  };

  programs.gh-dash = {
    enable = true;  # GitHub CLI
  };

  home.file.".local/bin/git-ssh-keygen" = lib.mkIf useForwardedSshAgent {
    executable = true;
    text = ''
      #!/bin/sh
      if [ -S "$HOME/.ssh/agent.sock" ]; then
        export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
      fi
      exec ${pkgs.openssh}/bin/ssh-keygen "$@"
    '';
  };

  home.file.".local/bin/git-ssh-default-key-command" = lib.mkIf useForwardedSshAgent {
    executable = true;
    text = ''
      #!/bin/sh
      if [ -S "$HOME/.ssh/agent.sock" ]; then
        export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
      fi
      exec ${pkgs.openssh}/bin/ssh-add -L
    '';
  };
}
