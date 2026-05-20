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
        rebase = false;
      };
      
      push = {
        default = "simple";
      };

      commit.gpgsign = true;
      gpg = {
        format = "ssh";
      } // lib.optionalAttrs useForwardedSshAgent {
        ssh.defaultKeyCommand = "ssh-add -L";
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
}
