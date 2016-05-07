"""
This contains some functions and values that are useful
"""

# the module, things we want to export should be added to it
helper = H = {}
_first.offer('helper',helper)

# modules to import as
# none


H.TWOPI = Math.PI * 2
H.HALFPI = Math.PI / 2

audioFile = "assets/bubbles.mp3"

# find the distance between two pos objects. pos = {x:num,y:num}
H.distance = (pos1, pos2) ->
	dx = pos1.x - pos2.x
	dy = pos1.y - pos2.y
	Math.sqrt (dx*dx + dy*dy)

# remove an item from an array
H.remove = (list,item) ->
	i = list.indexOf item
	if i != -1 
		list.splice(i,1)

# return a reversed array because apparently nothing does that? o_O
H.flipList = (list) ->
	l = []
	for item in list
		l.push item
	return l.reverse()


H.playSound = ->
	new Audio(audioFile).play()
