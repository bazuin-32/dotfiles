import { datetime } from "ts/vars/datetime"
import { username } from "ts/vars/username"
import { menuTitle, activeMenu, exitMenu, menuTransition } from "ts/vars/menustate"

const MenuHeading = () => Widget.Stack({
    children: {
        "greeting": Widget.Label({
            label: datetime.bind().as((dt) => {
                let timestr: string
                const hour = dt.getHours()
                if (hour < 12) {
                    timestr = "morning"
                } else if (hour < 18) {
                    timestr = "afternoon"
                } else {
                    timestr = "evening"
                }
                
                return `Good ${timestr}, ${username}`
            })
        }),
        "heading": Widget.Box({
            children: [
                Widget.Button({
                    child: Widget.Icon("go-previous-symbolic"),
                    className: "menu-button",
                    onClicked: () => {
                        exitMenu()
                    }
                }),
                Widget.Label({
                    label: menuTitle.bind()
                })
            ]
        })
    },
    shown: activeMenu.bind().as((m) => m == "main" ? "greeting" : "heading"),
    transition: menuTransition.bind(),
    className: "menu-heading"
})

export { MenuHeading }