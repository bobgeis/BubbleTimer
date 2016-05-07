
"""
This is a playground to see what passing modules around is like.
I really wanted a way to "import <module> as <name>" so that's what
I was aiming for.  This is obviously not how a real tool should work,  
but is good enough for this learning project and was fun to make.

A module puts the functions and values it would like to expose into
an object, and then offers that object (and a name) to _first.

At the same time, any module can request access to a module, and it
will be given an object that will later have the requested module's
exposed attributes.  Note that because things may load out of order,
request just returns an empty object!  

Once all the modules have been offered/requested, then there is an 
'apply' step that puts the offered objects' properties into the 
requested objects.  This is not ideal, consider better methods.  
"""


# expose an object 
F = _first = {}
root = (exports ? window)
root._first = _first

requestedModules = {}
appliedModules = {}
offeredModules = {}

# request an object representing a module
F.request = (name) ->
	if !requestedModules[name]
		requestedModules[name] = {}
		appliedModules[name] = false
	return requestedModules[name]

# offer an object representing a module
F.offer = (name,module) ->
	if offeredModules[name]
		console.log "namespace collision: #{name}"
	else
		offeredModules[name] = module

# copy an offered object to the requested one
F.applyModule = (name) ->
	if !offeredModules[name] 
		console.log "module never offered: #{name}"
		return false
	if !requestedModules[name]
		console.log "module never requested: #{name}"
		return false
	if appliedModules[name]
		console.log "module already applied: #{name}"
		return false
	for key, value of offeredModules[name]
		requestedModules[name][key] = value
	appliedModules[name] = true
	return true

# apply all offered objects to their requested ones
F.applyAllModules = ->
	for name, module of offeredModules
		F.applyModule name
	F.checkAllModulesApplied()

# check that all requested objects were applied
F.checkAllModulesApplied = ->
	allApplied = true
	for name, applied of appliedModules
		if !applied
			console.log "module not applied: #{name}"
			allApplied = false
	return allApplied


# add our scripts!
modulePaths = [
	"js/node_modules/underscore.js"
	"js/node_modules/jquery.js"
	"js/helper.js"
	"js/bubble.js"
	"js/main.js"
	]

addScript = (pathname) ->
	document.write('<script src="'+pathname+'"></script>')

for path in modulePaths
	addScript path



console.log "_first!"

