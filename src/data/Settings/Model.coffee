class Model extends Backbone.Model
	setSchematicById: (SID) ->
		console.log @schematics, SID
		schematic = @schematics.where urlId: SID
		if schematic.length
			@set schematic: schematic[0]
		else
			throw new "Can not find #{SID}"

module.exports = Model