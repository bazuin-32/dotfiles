function update() {
  old_dir="$(pwd)"

  sudo nix-channel --update
  nix flake update
  sudo nixos-rebuild switch

  # show the changes made in the update
  echo ''
  nvd diff $(command ls -d1v /nix/var/nix/profiles/system-*-link | tail -n 2)

  cd "${old_dir}"
}
