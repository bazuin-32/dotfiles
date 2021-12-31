# dotfiles
Dotfiles for my Arch Linux WM, compositor, bar, etc. setup.

I took a lot of inspiration from [lamalunderscore's dotfiles](https://github.com/lamalunderscore/dotfiles), so check those out too.

These are very much still a work in progress, so I am continuing to make changes.


## bspwm
For the most part this is just the default config.

## picom
I am using the [ibhagwan picom fork](https://github.com/ibhagwan/picom).
Most of this is from [lamalunderscore](https://github.com/lamalunderscore/dotfiles), as I'd never used a compositor before so I used those configs as a starting point. I did adjust a few things so that it would work better for my setup.

## polybar
Took the default config and made it my own. I looked at too many different examples and configs to name them all here.

## redshift
Not much here, just a simple config to get redshift to work so I don't destroy my eyes when I'm debugging at midnight.

## rofi
Almost all of the rofi configs are directly taken from [adi1090x's rofi repository](https://github.com/adi1090x/rofi), apart from a few minor modifications I made, like the [black.rasi theme for the powermenu](../blob/main/rofi/powermenu/styles/black.rasi) that I adapted from that of the text launcher in the original repo.

## sxhkd
Again, mostly default, with a few minor changes.

## termite
The only thing I've changed here is the font (I think), picom has done everything else for termite that I've needed to.