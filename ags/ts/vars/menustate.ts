import { Variable } from "resource:///com/github/Aylur/ags/variable.js";

const menuVisibility: { [monitor: number]: Variable<boolean> } = {
    0: new Variable(false),
    1: new Variable(false),
}

const mTitles = <const>["", "Calendar", "Audio"]
const mItems = <const>["main", "cal", "audio"]
type MItem = typeof mItems[number]

function isMItem(s: string): s is MItem {
    return !!mItems.find((item) => s == item)
}
function toMItem(s: string): MItem {
    let result: MItem
    if (isMItem(s)) {
        result = s
    } else {
        result = "main"
    }
    
    return result
}

const activeMenu: Variable<MItem> = new Variable(toMItem("main"))

const menuTitles: { [mItem: string]: string } = {}
mItems.forEach((val, i) => menuTitles[val] = mTitles[i])
const menuTitle: Variable<string> = Utils.derive([activeMenu], (active: MItem) => menuTitles[active])


export { MItem, menuVisibility, activeMenu, menuTitle }