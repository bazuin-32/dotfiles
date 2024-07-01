import { Variable } from "resource:///com/github/Aylur/ags/variable.js";

const menuVisibility: { [monitor: number]: Variable<boolean> } = {
    0: new Variable(false),
    1: new Variable(false),
}

export { menuVisibility }