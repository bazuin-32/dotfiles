import { datetime } from "ts/vars/datetime"
import { username } from "ts/vars/username"
import { menuTitle, activeMenu } from "ts/vars/menustate"

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
                    onClicked: () => { activeMenu.value = "main" }
                }),
                Widget.Label({
                    label: menuTitle.bind()
                })
            ]
        })
    },
    shown: activeMenu.bind().as((m) => m == "main" ? "greeting" : "heading"),
    transition: activeMenu.bind().as((m) => (m == "main" ? "slide_left" : "slide_right"))
})

export { MenuHeading }