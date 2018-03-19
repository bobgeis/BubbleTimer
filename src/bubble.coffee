"""
This contains a class that represents an individual bubble/circle timer.
It creates, updates, and draws the circles.
"""


# the module, things to export should be added to it
bubble = B = {}
_first.offer('bubble',bubble)

# # modules to import as
H = _first.request('helper')


# the circle timers
class CircleTimer
	constructor : (@ctx,@pos,@r,t,paused) ->
		@tM = @getDuration()
		@t = t or @tM
		@paused = paused or false
		# these gradients broke with chrome 65, replacing with flat colors for now
		# @_grad = @ctx.createRadialGradient @pos.x, @pos.y, @r, @pos.x, @pos.y, 0

	draw : ->
		# fill the circle
		if @t > 0
			if @paused
				# these gradients broke with chrome 65, replacing with flat colors for now
				# @_grad.addColorStop 0, "rgba(100, 0, 200, 0.5)"
				# @_grad.addColorStop 1, "rgba(255, 255, 255, 0.5)"
				# @ctx.fillStyle = @_grad
        @ctx.fillStyle = "rgba(100, 0, 200, 0.5)"
			else
				# these gradients broke with chrome 65, replacing with flat colors for now
				# @_grad.addColorStop 0, "rgba(0, 100, 200, 0.5)"
				# @_grad.addColorStop 1, "rgba(255, 255, 255, 0.5)"
				# @ctx.fillStyle = @_grad
        @ctx.fillStyle = "rgba(0, 100, 200, 0.5)"
			@ctx.beginPath()
			@ctx.arc(@pos.x,@pos.y,@r,-H.HALFPI,@getArc(),true)
			@ctx.lineTo(@pos.x,@pos.y)
			@ctx.fill()
			@ctx.closePath()
		# draw the outline
		if @t < 0
			if @paused
				@ctx.strokeStyle = '#FFAA00'
				@ctx.lineWidth = 3
				strokeArc = @getArc()
			else
				@ctx.strokeStyle = '#FF0000'
				@ctx.lineWidth = 3
				strokeArc = @getArc()
		else
			@ctx.strokeStyle = '#000000'
			@ctx.lineWidth = 1
			strokeArc = -H.HALFPI - H.TWOPI
		@ctx.beginPath()
		@ctx.arc(@pos.x,@pos.y,@r,-H.HALFPI,strokeArc,true)
		@ctx.stroke()
		@ctx.closePath()

	getDuration : ->
		@r * 1000

	getR : ->
		if @t > 0
			@r
		else
			(@tM + @t) / @tM * @r
	getArc : ->
		- H.HALFPI - @t / @tM * H.TWOPI

	update : (dt) ->
		if !@paused
			tOld = @t
			@t -= dt
			if tOld > 0 and @t < 0
				H.playSound()
		if @t < -@tM
			return this
		else
			return null

	posInside : (pos) ->
		r = H.distance @pos, pos
		if r < @r
			true
		else
			false

B.CircleTimer = CircleTimer









