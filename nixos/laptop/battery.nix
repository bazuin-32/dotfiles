{ pkgs, ... }: {
  services.upower.enable = true;

  boot.kernel.sysctl = {
    "vm.dirty_writeback_centisecs" = 1500;
  };

  systemd.services.setSysfsVars = {
    wantedBy = [ "multi-user.target" ];
    description = "Sets sysfs vars for power saving";
    serviceConfig.type = "oneshot";

    script = ''
      echo 1          > /sys/module/snd_hda_intel/parameters/power_save
      echo 'auto'     > /sys/bus/usb/devices/3-10/power/control
      echo 'auto'     > /sys/bus/pci/devices/0000:00:14.2/power/control
      echo 'auto'     > /sys/bus/pci/devices/0000:00:1f.5/power/control
      echo 'auto'     > /sys/bus/pci/devices/0000:00:1f.6/power/control
      echo 'auto'     > /sys/bus/pci/devices/0000:0a:00.0/power/control
      echo 'auto'     > /sys/bus/pci/devices/0000:04:00.0/power/control
      echo 'auto'     > /sys/bus/pci/devices/0000:00:04.0/power/control
      echo 'auto'     > /sys/bus/pci/devices/0000:09:00.0/power/control
      echo 'auto'     > /sys/bus/pci/devices/0000:00:1f.0/power/control
      echo 'auto'     > /sys/bus/pci/devices/0000:00:00.0/power/control
      echo 'disabled' > /sys/class/net/enp0s31f6/device/power/wakeup
    '';
  };
}
