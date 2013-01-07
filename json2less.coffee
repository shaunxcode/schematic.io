vars = require "./src/less/variables"

require("fs").writeFile "lib/variables.js", "module.exports=#{JSON.stringify vars}"

output = ''
for key, val of vars
	output += "@#{key}: #{val};\n"

console.log output
