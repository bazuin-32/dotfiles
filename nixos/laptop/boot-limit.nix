{ ... }: {
  # TODO: enlarge efi system partition so this is not needed
  # currently the windows efi partition is being used, which
  # is too small (100mb)
  boot.loader.systemd-boot.configurationLimit = 2;
}
