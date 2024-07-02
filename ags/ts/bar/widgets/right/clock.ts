import { datetime } from "ts/vars/datetime"

const Clock = () => Widget.Label({
    className: "clock",
    label: datetime.bind().as((dt: Date) => dt.toLocaleString(
        "en-US",
        { hour: "numeric", minute: "numeric" }
    ))
})

export { Clock }