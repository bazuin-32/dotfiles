import Hyprland from "gi://AstalHyprland"

import { For } from "ags"

import { workspaces_with_active } from "../utils/state"

const hyprland = Hyprland.get_default()

function BarWorkspaces() {
  return (
    <box>
      <For each={workspaces_with_active}>
        {(ws: {id: number, isActive: boolean}) => (
          <button
            onClicked={() => hyprland.dispatch("workspace", ws.id.toString())}
            cssClasses={ws.isActive ? ["workspace", "active"] : ["workspace"]}
          >
            <label label={ws.id.toString()} />
          </button>
        )}
      </For>
    </box>
  )
}

export { BarWorkspaces }