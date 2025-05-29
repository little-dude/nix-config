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
    plugins = [
      {
        name = "fish-exa";
        src = pkgs.fetchFromGitHub {
          owner = "gazorby";
          repo = "fish-exa";
          rev = "92e5bcb762f7c08cc4484a2a09d6c176814ef35d";
          hash = "sha256-kw4XrchvF4SNNoX/6HRw2WPvCxKamwuTVWdHg82Pqac=";
        };
      }
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
