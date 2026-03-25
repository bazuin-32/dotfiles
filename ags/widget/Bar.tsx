import app from "ags/gtk4/app"
import { Astal, Gtk, Gdk } from "ags/gtk4"
import { execAsync } from "ags/process"
import { createPoll } from "ags/time"
import { For, Accessor } from "ags"

import { BarWorkspaces } from "./BarWorkspaces"
import { BarWindowTitle } from "./BarWindowTitle"
import { BarSysTray } from "./BarSysTray"
import { BarMultiMenu } from "./BarMultiMenu"


export default function Bar(gdkmonitor: Gdk.Monitor) {
  const time = createPoll("", 1000, "date")
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

  return (
    <window
      visible
      name="bar"
      class="Bar"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | RIGHT}
      application={app}
    >
      <centerbox cssName="centerbox">
        <box $type="start" cssClasses={["left-container"]}>
          <BarWorkspaces />
        </box>
        <box $type="center" cssClasses={["center-container"]}>
          <BarWindowTitle />
        </box>
        <box $type="end" cssClasses={["right-container"]}>
          <BarSysTray />
          <BarMultiMenu />
        </box>
      </centerbox>
    </window>
  )
}
