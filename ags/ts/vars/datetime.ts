const datetime_str = Variable("", {
    poll: [1000, 'date']
})

const datetime = datetime_str.bind().as(function (str: string) {
    const dt = new Date()
    dt.setTime(Date.parse(str))
    return dt
})

export { datetime }