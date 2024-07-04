import { Variable } from "resource:///com/github/Aylur/ags/variable.js";

const menuVisibility: { [monitor: number]: Variable<boolean> } = {
    0: new Variable(false),
    1: new Variable(false),
}

const mTitles = <const>["", "Calendar", "Audio", "Network", "Battery", "Audio Devices"]
const mItems = <const>["main", "cal", "audio", "network", "battery", "audiodev"]
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


const mTransitions = <const>["slide_left", "slide_right"]
type MTransition = typeof mTransitions[number]
function isMTransition(s: string): s is MTransition {
    return !!mTransitions.find((item) => s == item)
}
function toMTransition(s: string): MTransition {
    let result: MTransition
    if (isMTransition(s)) {
        result = s
    } else {
        result = "slide_left"
    }
    
    return result
}


const activeMenu: Variable<MItem> = new Variable(toMItem("main"))
const menuHist: Variable<MItem[]> = new Variable([toMItem("main")])
const menuTransition: Variable<MTransition> = new Variable(toMTransition("slide_left"))

function enterMenu(menu: MItem) {
    menuHist.value.push(menu)
    menuTransition.value = "slide_left"
    activeMenu.value = menu
}
function exitMenu() {
    menuHist.value.pop()
    menuTransition.value = "slide_right"
    activeMenu.value = menuHist.value[menuHist.value.length - 1]
}
function resetMenu() {
    menuHist.value = ["main"]
    menuTransition.value = "slide_right"
    activeMenu.value = "main"
}

const menuTitles: { [mItem: string]: string } = {}
mItems.forEach((val, i) => menuTitles[val] = mTitles[i])
const menuTitle: Variable<string> = Utils.derive([activeMenu], (active: MItem) => menuTitles[active])


export { MItem, menuVisibility, activeMenu, menuTransition, menuTitle, enterMenu, exitMenu, resetMenu, toMItem }