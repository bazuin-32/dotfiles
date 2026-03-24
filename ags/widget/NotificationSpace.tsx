import { Astal, Gtk, Gdk } from "ags/gtk4"
import AstalNotifd from "gi://AstalNotifd"
import { createState, onCleanup, For } from "ags"
import Notification from "./Notification"

const notifd = AstalNotifd.get_default()

const [notifications, setNotifications] = createState(new Array<AstalNotifd.Notification>(),)


export default function NotificationSpace(monitor: Gdk.Monitor) {
    const notifiedHandler = notifd.connect("notified", (_, id, replaced) => {
        const notification = notifd.get_notification(id)
        
        // ignore null notifications
        if (!notification) {
            return
        }

        // if the notification was replaced, update it in the state, otherwise add it
        if (replaced && notifications.peek().some((n) => n.id === id)) {
            setNotifications((ns) => ns.map((n) => (n.id === id ? notification : n)))
        } else {
            setNotifications((ns) => [...ns, notification])
        }
    })

    const resolvedHandler = notifd.connect("resolved", (_, id) => {
        setNotifications((ns) => ns.filter((n) => n.id !== id))
    })
    
    onCleanup(() => {
        notifd.disconnect(notifiedHandler)
        notifd.disconnect(resolvedHandler)
    })

    return (
        <window
            $={(self) => onCleanup(() => self.destroy())}
            class="NotificationSpace"
            gdkmonitor={monitor}
            visible={notifications((ns) => ns.length > 0)}
            anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.RIGHT}
        >
            <box orientation={Gtk.Orientation.VERTICAL}>
                <For each={notifications}>
                    {(notification) => <Notification notification={notification} />}
                </For>
            </box>
        </window>
    )
} 