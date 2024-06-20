const datetime = Variable(new Date(), {
    poll: [1000, () => new Date() ]
})

export { datetime }