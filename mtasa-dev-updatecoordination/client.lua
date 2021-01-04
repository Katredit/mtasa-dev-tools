local sx , sy   = guiGetScreenSize()
local lastClick = getTickCount()
local state     = 0

states = {
    [1] = {
        image = {
            ["main"] = images["move"] ,
            ["x"]    = images["movex"],
            ["y"]    = images["movey"],
            ["z"]    = images["movez"],
        },
        color = tocolor(255 , 48 , 48 , 50),
    },
    [2] = {
        image = {
            ["main"] = images["rotate"] ,
            ["x"]    = images["rotatex"],
            ["y"]    = images["rotatey"],
            ["z"]    = images["rotatez"],
        },
        color = tocolor(0 , 153 , 255 , 50),
    },
    [3] = {
        image = {
            ["main"] = images["scale"] ,
            ["x"]    = images["scalex"],
            ["y"]    = images["scaley"],
            ["z"]    = images["scalez"],
        },
        color = tocolor(100 , 255 , 100 , 50),
    },
    [4] = {
        image = {
            ["main"] = images["save"]
        },
        color = tocolor(255 , 255 , 48 , 50),
    }
}

function addMoverObject(obj)
	if obj then
		object = obj
		addEventHandler('onClientRender', getRootElement(), draw)
	end
end
addEvent('mover.object',true)
addEventHandler('mover.object', getRootElement(), addMoverObject)

function draw()
    showCursor(true)
    local x , y = getScreenFromWorldPosition(object.position)
    local ox , oy , oz = getElementPosition(object)
    local rx, ry, rz = getElementRotation(object)
    local mx, my, mz = getObjectScale(object)

    oz = oz + 1
    
    if x and y then 

        for i=1, 4 do 

            local size = 22

            if isMouseInPosition(x , y , size , size) then

                if getKeyState("mouse1") and lastClick < getTickCount() then 
                    lastClick = getTickCount() + 200
                    state = i
                    if state == 1 then
						lastX , lastY , lastZ = ox , oy , oz-1
					elseif state == 2 then
						lastX , lastY , lastZ = rx , ry , rz
					elseif state == 3 then
						lastX , lastY , lastZ = mx , my , mz
					elseif state == 4 then
						state = 0
                    	removeEventHandler("onClientRender", getRootElement(), draw) 
                    	showCursor(false)
					end
                end

                size = 24

            end

            roundedRectangle(x , y , size , size , i==state and states[i].color or tocolor(0 , 0 , 0 , 100))
            dxDrawImage(x + (size-16)/2 , y + (size-16)/2 , 16 , 16 , states[i].image.main)
            x = x + size + 3

            size = 22

            if i == state then 

                for k , v in ipairs({"lx" , "ly" , "lz"}) do 

                    lx , ly , lz = ox , oy , oz
                    loadstring(v.." = "..v.." + 0.5")()

                    local x , y = getScreenFromWorldPosition(lx , ly , lz)

                    if x and y then 
                    	if state > 0 then
	                        dxDrawLine3D(ox , oy , oz , lx , ly , lz)
	                        roundedRectangle(x , y , size , size , tocolor(0 , 0 , 0 , 100))
	                        dxDrawImage(x + (size-16)/2 , y + (size-16)/2 , 16 , 16 , states[state].image.main)
	                        if isMouseInPosition(x , y , size , size) and getKeyState("mouse1") and lastClick < getTickCount() then
	                            lastCoordinate = "last"..string.upper(v:gsub("l" , ""))
	                            lastCX, lastCY = getCursorPosition()
	                            lastClick = getTickCount() + 200
	                        end
	                    end
                    end

                end

            end

        end

    end
end

function move( x , y )
    if not getKeyState("mouse1") or y == lastCY or not lastCY then return end
    if state > 0 then
	    local str = y < lastCY and "+" or "-"
	    loadstring(lastCoordinate.." = "..lastCoordinate.." "..str.." 0.05")()
	    if state == 1 then
	    	setElementPosition(object, lastX, lastY, lastZ)
	    elseif state == 2 then
	    	setElementRotation(object, lastX, lastY, lastZ)
	    elseif state == 3 then
	    	setObjectScale(object, lastX, lastY, lastZ)
	    end
	    lastCY = y
	end
end
addEventHandler( "onClientCursorMove", getRootElement(), move)