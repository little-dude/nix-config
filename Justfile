deploy:
  sudo nixos-rebuild switch --flake .

debug:
  nixos-rebuild switch --flake . --show-trace --verbose

format:
  alejandra .

up:
  nix flake update

upp:
  nix flake update

history:
  nix profile history --profile /nix/var/nix/profiles/system

repl:
  nix repl -f flake:nixpkgs

clean:
  # remove all generations older than 7 days
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

gc:
  # garbage collect all unused nix store entries
  sudo nix-collect-garbage --delete-old
  nix-collect-garbage --delete-old
