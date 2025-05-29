{pkgs, ...}: {
  home.packages = [pkgs.fzf pkgs.eza pkgs.grc];
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    shellAliases = {
      "ls" = "eza --group --header --group-directories-first";
      "l" = "eza --group --header --group-directories-first";
      "la" = "eza --group --header --group-directories-first --all";
      "ll" = "eza --long --group --header --group-directories-first --git";
      "lla" = "eza --long --group --header --group-directories-first --git --all";
      "lai" = "eza --group --header --group-directories-first --all --git-ignore";
      "lli" = "eza --long --group --header --group-directories-first --git --git-ignore";
      "llai" = "eza --long --group --header --group-directories-first --git --all --git-ignore";
      "tree" = "eza --tree";
      "treea" = "eza --tree --all";
      "treei" = "eza --tree --git-ignore";
      "treeai" = "eza --tree --all --git-ignore";
      "treel" = "eza --tree --level";
      "treeli" = "eza --tree --git-ignore --level";
    };
    plugins = [
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
      {
        name = "grc";
        src = pkgs.fishPlugins.grc.src;
      }
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
    ];
  };
}
