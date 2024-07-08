import { Binding } from "resource:///com/github/Aylur/ags/service.js";

type RowItem = string | Binding<any, any, string>

const rowsToCols = <T>(rows: T[][]) => rows[0].map(
    (col, i) => rows.map(
        (row) => row[i]
    )
)

const Column = (rows: RowItem[], hpack: "start" | "end") => Widget.Box({
    hpack,
    vertical: true,
    children: rows.map(row => Widget.Label({
        hpack,
        label: row
    }))
})

const Table = (data: RowItem[][]) => Widget.CenterBox({
    startWidget: Column(rowsToCols(data)[0], "start"),
    endWidget: Column(rowsToCols(data)[1], "end")
})

export { Table }