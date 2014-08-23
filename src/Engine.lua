local class = require 'middleclass'

local Engine = class('Engine')

function Engine:initialize(screen)
	self.screen = screen
	self.nextScreen = nil

	self.TILESIZE = 64
	self.TIMEFORONEDAY = 24
end

function Engine:update(dt)
	if self.nextScreen ~= nil then
		self.screen:onQuit()
		self.screen = self.nextScreen
		self.nextScreen = nil
	end

	self.screen:update(dt)
end

function Engine:draw()
	self.screen:draw()
end

--SCREEN

function Engine:screen_setNext(screen)
	self.nextScreen = screen
end

function Engine:screen_getCurrent()
	return self.screen
end

--VECTOR

function Engine:vector_normalize(v)
	local l = self:vector_Length(v)
	v.x = v.x / l
	v.y = v.y / l

	return v
end

function Engine:vector_length(v)
	return math.sqrt(v.x * v.x + v.y * v.y)
end

function Engine:vector_of(pos1, pos2)
	local v = {}
	v.x = pos2.x - pos1.x
	v.y = pos2.y - pos1.y
	return v
end

function Engine:vector_rotate(v, angle)
	local r = {}
	r.x = v.x * math.cos(angle) - v.y * math.sin(angle)
	r.y = v.x * math.sin(angle) + v.y * math.cos(angle)
	return r
end

function Engine:vector_copy(v)
	local r = {}
	r.x = v.x
	r.y = v.y
	return r
end

--AABB
function Engine:AABB_circle(box, circle, boolReturnPos)
	local pos = {}
	pos.x = circle.pos.x
	pos.y = circle.pos.y

	if pos.x > box.x + box.w - 1 then
		pos.x = box.x + box.w - 1
	elseif pos.x < box.x then
		pos.x = box.x
	end
	if pos.y > box.y + box.h - 1 then
		pos.y = box.y + box.h - 1
	elseif pos.y < box.y then
		pos.y = box.y
	end

	local collision = self:Circle_point(circle, pos)

	if boolReturnPos then
		return collision, pos
	else
		return collision
	end
end

function Engine:AABB_inCircle(box, circle, boolReturnPos)
	local pos = {}
	pos.x = circle.pos.x
	pos.y = circle.pos.y

	if pos.x > box.x + box.w - 1 then
		pos.x = box.x + box.w - 1
	elseif pos.x < box.x then
		pos.x = box.x
	end
	if pos.y > box.y + box.h - 1 then
		pos.y = box.y + box.h - 1
	elseif pos.y < box.y then
		pos.y = box.y
	end

	
	local collision = self:Circle_point(circle, pos)
	local pos = {}
	pos[0] = {x = box.x, y = box.y}
	pos[1] = {x = box.x + box.w-1, y = box.y}
	pos[2] = {x = box.x, y = box.y + box.h-1}
	pos[3] = {x = box.x + box.w, y = box.y + box.h}

	for i = 0, 3 do
		collision = collision and self:Circle_point(circle, pos[i])
	end

	if boolReturnPos then
		return collision, pos
	else
		return collision
	end
end

function Engine:AABB_point(box, point)
	return point.x >= box.x and point.x <= box.x + box.w - 1 and 
			point.y >= box.y and point.y <= box.y + box.h - 1 
end

function Engine:AABB_AABB(box1, box2)
	return	box2.x				<= box1.x + box1.w -1
		and box2.x + box2.w -1	>= box1.x 
		and box2.y 				<= box1.y + box1.h -1
		and box2.y + box2.h -1	>= box1.y
end

function Engine:Circle_point(circle, point)
	local v = self:vector_of(circle.pos, point)
	return self:vector_length(v) <= circle.r
end

function Engine:Circle_circle(circle, circle2)
	return self:vector_length(self:vector_of(circle.pos, circle2.pos)) < circle.r + circle2.r
end

return Engine