xplr.config.modes.builtin.default.key_bindings.on_key.F = {
    help = "fuzzy search",
    messages = {
        { SwitchModeCustom = "fuzzy_search" }
    }
}

xplr.config.modes.custom.fuzzy_search = {
    name = "fuzzy search",
    key_bindings = {
        on_key = {
          f = {
            help = "search from current directory",
            messages = {
              { BashExec0 = [===[
                  abspath="$(readlink -f ${XPLR_FOCUS_PATH:?})"
                  dir="$(dirname $abspath)"
                  pattern="s#$HOME#~#g"
                  revpattern="s#~#$HOME#g"

                  PTH="$(
                      fd '.' $dir --color=always \
                      | sort \
                      | sed $pattern \
                      | fzf --ansi \
                      | sed $revpattern
                  )"

                  if [ -f "$PTH" ]; then
                    echo FocusPath: "'"${PTH:?}"'" >> "${XPLR_PIPE_MSG_IN:?}"
                  elif [ -d "$PTH" ]; then
                    echo ChangeDirectory: "'"${PTH:?}"'" >> "${XPLR_PIPE_MSG_IN:?}"
                  else
                    echo LogError: "'"${PTH:?}"'" is not a file or directory >> "${XPLR_PIPE_MSG_IN:?}"
                  fi
              ]===] },
              "PopMode"
            }
          },

          F = {
            help = "search from home directory",
            messages = {
              { BashExec0 = [===[
                  dir="$HOME"
                  pattern="s#$HOME#~#g"
                  revpattern="s#~#$HOME#g"

                  PTH="$(
                      fd '.' $dir --color=always \
                      | sort \
                      | sed $pattern \
                      | fzf --ansi \
                      | sed $revpattern
                  )"

                  if [ -f "$PTH" ]; then
                          echo FocusPath: "'"${PTH:?}"'" >> "${XPLR_PIPE_MSG_IN:?}"
                  elif [ -d "$PTH" ]; then
                          echo ChangeDirectory: "'"${PTH:?}"'" >> "${XPLR_PIPE_MSG_IN:?}"
                  else
                          echo LogError: "'"${PTH:?}"'" is not a file or directory >> "${XPLR_PIPE_MSG_IN:?}"
                  fi
              ]===] },
              "PopMode"
            }
          },

          escape = {
            help = "exit fuzzy search",
            messages = { "PopMode" }
          }
        }
    }
}
