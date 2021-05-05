module.exports.setEnv = (name, value) => {
	process.env[name] = value

	return "OK"
}

module.exports.removeEnv = (name) => {
	delete process.env[name]

	return "OK"
}