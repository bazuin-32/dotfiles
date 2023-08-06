{ pkgs, ... }: {
  services.upower.enable = true;

  # services.udev.extraRules = let
  #   log_battery = pkgs.writeShellScript "log_battery.sh" ''
  #     log_file='/var/log/battery.log'
  #     last_time=$(tail -n 1 $log_file | cut -d ' ' -f 1)
  #     current_time=$(date '+%s')
  #     diff=$(( current_time - last_time ))
  #
  #     if [[ $diff -lt 5 ]]; then
  #       exit
  #     fi
  #
  #     echo "$current_time $(cat /sys/class/power_supply/BAT0/capacity)% $@" >> $log_file
  #   '';
  # in ''
  #   SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${log_battery} charging"
  #   SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${log_battery} discharging"
  # '';
}
