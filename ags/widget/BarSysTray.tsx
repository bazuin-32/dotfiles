import { Gtk } from "ags/gtk4"
import Tray from "gi://AstalTray"

import { For } from "ags"

import { tray_items } from "../utils/state"

// helper to popup the model-based popover on a widget
function popup_model_menu_for(self: Gtk.Button, item: Tray.TrayItem) {
  try {
    item.about_to_show && item.about_to_show()

    self.insert_action_group("dbusmenu", item.actionGroup)

    const pop = Gtk.PopoverMenu.new_from_model(item.menuModel)
    pop.cssClasses = ["popover"]
    pop.set_parent(self)
    pop.popup()
  } catch (e) {
    log(`tray popup failed: ${e}`)
  }
}

function BarSysTray() {
  return (
    <box>
      <For each={tray_items}>
        {(item) => (
          <button
            cssClasses={["systray-item"]}
            tooltipText={item.title}

            // reliable left-click handler — will fire every time
            onClicked={() => {
              try {
                // if the tray item is menu-only, prefer opening the menu
                if (item.isMenu) {
                  // If you want left click to open the menu for menu-only items:
                  item.about_to_show && item.about_to_show()
                  // We can't call popup() from here because we need the widget instance;
                  // that is handled by the right-click controller below which will also
                  // create the popover on demand. If you want left-click to open menu,
                  // see the note below about storing popover in closure.
                } else {
                  // Call activate — many tray apps accept 0,0 if you don't have global coords
                  item.activate(0, 0)
                }
              } catch (e) { log(`tray activate failed: ${e}`) }
            }}

            // capture the real widget to attach right-click controller
            $={(self) => {
              // only set up right-click handling; leave left-click to onClicked
              // right-click gesture (button 3)
              const gSecondary = new Gtk.GestureClick({ button: 3 })
              gSecondary.connect('pressed', (g, n_press, x, y) => {
                popup_model_menu_for(self, item)
              })
              self.add_controller(gSecondary)
              return
            }}
          >
            <image gicon={item.gicon} />
          </button>
        )}
      </For>
    </box>
  )
}

export { BarSysTray }