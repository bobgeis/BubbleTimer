"""
Bubble Timer

bubbles audio from:
http://soundbible.com/1137-Bubbles.html

This is a learning project/playground made while learning coffeescript.
The ostensible motivation was to create a program that could be used
to time the steeping of tea.  In that regard it was successful.

"""

"""

Some Things learned:

1) Shallow namespaces can be bad.  Not a problem here though,
this program is way too small!  To experiment i made first.coffee
which just passes modules around, but is a little wonky.
I can see some of the advantages of something more sophisticated.


Things to try:

1) Real package/module managers and related tools.

1a) If not the above, then make something better than _first

2) Images in canvas, multiple canvases, things that aren't canvas.
"""

# the module, things to export should be added to it
# main = {}
# _first.offer('main',main)

# modules to import as
H = _first.request('helper')
B = _first.request('bubble')


# constants and globals
# this stuff should probably be put in a class or something tidy
# but having it messy will work while experimenting

minDist = 5
jcanvas = null
canvas = null
ctx = null
stopToken = 0
mouseDown = false
start = {x:0,y:0}	# start position of a click-drag
stop = {x:0,y:0}	# stop position of a click-drag
circles = [] 		# list of existin circles
cull_circles = [] 	# list of circles to cull
lastTime = 0 		# timestamp of last frame
pauseAll = false 	# half updates?
windowResized = false 	# window was resized since the last frame
audioFile = "assets/bubbles.mp3"

setup = ->
	jcanvas = $('<canvas>',{'id':'clockCanvas'})
	# we can append the canvas to a special div for it (often a good idea)
	$('#addCanvasHere').append(jcanvas)
	# OR we can append it directly to the body, if there's nothing else
	# $('body').append(jcanvas)
	jcanvas.mousedown(handleMouseDown)
	jcanvas.mouseup(handleMouseUp)
	jcanvas.mousemove(handleMouseMove)
	jcanvas.mouseout(handleMouseOut)
	canvas = jcanvas[0]
	ctx = canvas.getContext '2d'
	setCanvasSize()
	window.addEventListener('keyup',handleKeyUp)
	window.onresize = handleWindowResize
	loadCircles()
	# console.log window
	# console.log document
	# console.log jdoc
	# console.log jcanvas
	# console.log canvas
	# console.log ctx


rafLoop = (time = 0) ->
	dt = time - lastTime
	stopToken = requestAnimationFrame rafLoop
	update(dt)
	draw(dt)
	lastTime = time



update = (dt) ->
	# update the circles
	if !pauseAll
		for circle in circles
			cull_circle = circle.update(dt)
			if cull_circle
				cull_circles.push cull_circle
	if cull_circles.length > 0
		circles = _.difference(circles,cull_circles)
		cull_circles = []		

draw = (dt) ->

	# we may have to resize the window
	if windowResized
		setCanvasSize()

	# draw the background color
	ctx.fillStyle = chooseBgColor()
	ctx.fillRect(0,0,canvas.width,canvas.height)

	# draw the circles
	for circle in circles
		circle.draw()

	# draw the new mouse circle
	dist = H.distance(start,stop)
	if mouseDown and dist > minDist
		ctx.fillStyle = '#00BBAA'
		ctx.beginPath()
		ctx.arc(start.x,start.y,dist,0,H.TWOPI)
		ctx.fill()
		ctx.closePath()
		ctx.fillStyle = '#000000'
		ctx.font = '30px Arial'
		timeInMinutes = "#{Math.floor(dist/60)}:#{('0'+(Math.floor(dist)%60)).slice(-2)}"
		ctx.fillText timeInMinutes, start.x, start.y


chooseBgColor = ->
	if pauseAll
		return '#888855'
	if circles.length == 0
		return '#555555'
	for circle in circles
		if circle.t > 0
			return '#DFDFD0'
	return '#885555'





setCanvasSize = (context = ctx) ->
	# apparently we need to take off a few pixels,
	# otherwise unnecessary scrollbars appear
	context.canvas.width = window.innerWidth
	context.canvas.height = window.innerHeight
	windowResized = false

# this gets the mouse position in the canvas' coordinates!
getMousePos = (event, canvas = canvas) ->
	{x: event.clientX - jcanvas.offset().left, y: event.clientY - jcanvas.offset().top}


# use local storage to save and get circles bt sessions!
saveCircles = ->
	localStorage.setItem('circles',JSON.stringify(circles))

loadCircles = ->
	jcircles = JSON.parse(localStorage.getItem('circles')) or []
	circles = []
	for jcircle in jcircles
		circle = new B.CircleTimer(ctx,jcircle.pos,jcircle.r,jcircle.t,jcircle.paused)
		circles.push circle

# event handlers!
handleMouseDown = (event) ->
	start = getMousePos(event)
	stop = start
	mouseDown = true

handleMouseUp = (event)	->
	if !mouseDown then return
	stop = getMousePos(event)
	mouseDown = false
	dist = H.distance(start,stop)
	if dist > minDist
		circle = new B.CircleTimer(ctx,start,dist)
		circles.push circle
	else
		for circle in H.flipList circles
			if circle.posInside stop
				if event.shiftKey 
					cull_circles.push circle
					return 	# return if we only want to affect the top circle
				else
					circle.paused = !circle.paused
					return 	# return if we only want to affect the top circle

handleMouseMove = (event) ->
	if !mouseDown then return
	stop = getMousePos(event)

handleMouseOut = (event) ->
	mouseDown = false

handleKeyUp = (event) ->
	if event.code == 'Space'
		pauseAll = !pauseAll
	if event.code == 'Enter'
		saveCircles()	

handleWindowResize = (event) ->
	windowResized = true



# this will be executed once everything else is finished!
$ -> 
	console.log '$ -> begins'
	_first.applyAllModules()
	setup()
	rafLoop()

console.log 'main script loaded'	# this is executed before the stuff in $ -> !




