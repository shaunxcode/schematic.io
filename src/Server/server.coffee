express = require "express"

app = express()
server = app.listen 6699
app.configure ->
	app.use express.static "./public"

	#POST users 
	##creates user
	
	#POST users/authenticate

	#GET users

	#GET schematics

	#POST schematics

	#GET schematics/:id

