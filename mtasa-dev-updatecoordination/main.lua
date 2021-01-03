_dxCreateTexture = dxCreateTexture

function dxCreateTexture(png , ...)
    return _dxCreateTexture("files/"..png..".png" , ...)
end

images = setmetatable({} , {
    __newindex = function(table , key , value)

        value = dxCreateTexture(key)
        rawset(table , key , value)

    end
})

images["move"] = false
images["rotate"] = false
images["save"] = false
images["scale"] = false

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
	if (not borderColor) then
		borderColor = tocolor(0, 0, 0, 200);
	end
	if (not bgColor) then
		bgColor = borderColor;
	end
	dxDrawRectangle(x, y, w, h, bgColor, postGUI);
	dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI);
	dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI);
	dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI);
	dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI);
end