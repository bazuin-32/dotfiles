import { datetime } from "ts/vars/datetime"

const DtLabel = () => Widget.Label({
    label: datetime.bind().as((dt) => dt.toLocaleString(
        "en-US",
        {
            weekday: "long",
            month: "long",
            day: "numeric",
            year: "numeric"
        }
    )) 
})

const Calendar = () => Widget.Calendar({
    showDayNames: true,
    showDetails: true,
    showHeading: true,
    showWeekNumbers: true
})

export { DtLabel, Calendar }