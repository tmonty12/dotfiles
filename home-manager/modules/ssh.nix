{ config, pkgs, lib, useForwardedSshAgent ? false, ... }:

{
  programs.ssh = {
    enable = true;
    includes = [
      "~/.ssh/config.local"
      "~/.brev/ssh_config"
    ];
    matchBlocks = {
      "*" = {
        extraOptions = {
          "AddKeysToAgent" = "yes";
          "ServerAliveInterval" = "60";
          "ServerAliveCountMax" = "3";
        } // lib.optionalAttrs pkgs.stdenv.isDarwin {
          "UseKeychain" = "yes";
        };
        controlMaster = "auto";
        controlPath = "~/.ssh/sockets/%r@%h-%p";
        controlPersist = "600";
      };
      "github.com" = {
        hostname = "github.com";
        user = "git";
      } // lib.optionalAttrs useForwardedSshAgent {
        identitiesOnly = false;
        addKeysToAgent = "no";
      } // lib.optionalAttrs (!useForwardedSshAgent) {
        identityFile = "~/.ssh/id_rsa";
        identitiesOnly = true;
        addKeysToAgent = "yes";
      };
    };
  };

  # Ensure SSH control socket directory exists
  home.activation.sshSocketDir = ''
    mkdir -p ~/.ssh/sockets
  '';

  # Enable a local ssh-agent on Linux unless this host is expected to use
  # an agent forwarded by the client that SSHed into it.
  services.ssh-agent.enable = pkgs.stdenv.isLinux && !useForwardedSshAgent;

  # macOS-specific helper: automatically add key to agent/keychain if not already present
  home.activation.sshAddKey = lib.mkIf pkgs.stdenv.isDarwin ''
    if [ -f ~/.ssh/id_rsa ]; then
      # Only add key if it's not already in the agent
      if ! /usr/bin/ssh-add -l 2>/dev/null | grep -q id_rsa; then
        /usr/bin/ssh-add --apple-use-keychain ~/.ssh/id_rsa 2>/dev/null || true
      fi
    fi
  '';

  # Linux: add your key automatically on login if agent is running and key not already loaded
  home.activation.sshAddKeyLinux = lib.mkIf (pkgs.stdenv.isLinux && !useForwardedSshAgent) ''
    if [ -f ~/.ssh/id_rsa ]; then
      # Check if agent is running and key is not already loaded
      if ! ssh-add -l >/dev/null 2>&1 | grep -q id_rsa; then
        eval "$(ssh-agent -s)" >/dev/null 2>&1 || true
        ssh-add ~/.ssh/id_rsa >/dev/null 2>&1 || true
      fi
    fi
  '';
}
