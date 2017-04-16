local utils = {}

function utils.new_debug_image(width, height, fill_color)
	local image_data = love.image.newImageData(width, height)
	fill_color = fill_color or {255, 255, 255}
	for x=0,width-1 do
		for y=0,height-1 do
			image_data:setPixel(x, y, unpack(fill_color))
		end
	end
	return love.graphics.newImage(image_data)
end

-- is point in polygon?
function utils.pnpoly(vertices, x, y)
	local nvert = #vertices/2
	local inside, i, j = false, 1, nvert
	while i <= nvert do
		local vxi, vyi, vyj = vertices[i*2-1], vertices[i*2], vertices[j*2]
		if (((vyi > y) ~= (vyj > y)) and
				(x < (vertices[j*2-1]-vxi) * (y-vyi) / (vyj-vyi) + vxi)) then
			inside = not inside
		end
		j = i
		i = i + 1
	end
	return inside
end

function utils.key_as_analog(left,right,up,down)
	local dx, dy = 0, 0
	if love.keyboard.isDown(left)  then dx = dx - 1 end
	if love.keyboard.isDown(right) then dx = dx + 1 end
	if love.keyboard.isDown(up)    then dy = dy - 1 end
	if love.keyboard.isDown(down)  then dy = dy + 1 end
	return dx, dy
end

return utils