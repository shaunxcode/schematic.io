express = require "express"

app = express()
server = app.listen 6699
app.configure ->
	app.use express.static "./public"


