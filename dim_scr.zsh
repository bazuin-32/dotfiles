# gradually dims the screen
dim_scr() {
        for i in $(seq 1 -0.01 0.01); do xrandr --output HDMI-0 --brightness $i && xrandr --output HDMI-1 --brightness $i; done
}
