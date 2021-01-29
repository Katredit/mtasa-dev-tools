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

mods = {
    [1] = "etElementPosition",
    [2] = "etElementRotation",
    [3] = "etObjectScale",
}

function addMoverObject(obj)
	if obj then
        object = obj
        states["object"] = object
		addEventHandler('onClientPreRender', getRootElement(), draw)
	end
end
addEvent('mover.AddObject',true)
addEventHandler('mover.AddObject', getRootElement(), addMoverObject)


function draw()
    local x , y = getScreenFromWorldPosition(object.position)
    local ox , oy , oz = getElementPosition(object)

    oz = oz + 1
    
    if x and y then 

        for i=1, 4 do 

            local size = 22

            if isMouseInPosition(x , y , size , size) then

                if getKeyState("mouse1") and lastClick then 
                    lastClick = false
                    state = i

                    if state == 4 then
                        state = 0
                        removeEventHandler("onClientPreRender", getRootElement(), draw) 
                    	showCursor(false)
                    return end

                    lastMode = mods[state]

                end

                size = 24

            end

            if not getKeyState("mouse1") then
                lastClick = true
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
	                        if isMouseInPosition(x , y , size , size) and getKeyState("mouse1") and lastClick then
	                            lastCoordinate = string.lower(v:gsub("l" , ""))..string.lower(v:gsub("l" , ""))
	                            lastCX, lastCY = getCursorPosition()
	                            lastClick = false
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
        local value = state == 2 and "0.15" or "0.05"

        if state == 1 then
            xx , yy , zz = getElementPosition(object)
        elseif state == 2 then
            xx , yy , zz = getElementRotation(object)
        elseif state == 3 then
            xx , yy , zz = getObjectScale(object)
        end

        loadstring("xx , yy , zz = g"..mods[state].."(object)")
        loadstring(lastCoordinate.." = "..lastCoordinate.." "..str..value)()

        loadstring("s"..mods[state].."(object , xx , yy , zz)")()
	    
        lastCY = y
        
    end
    
end
addEventHandler( "onClientCursorMove", getRootElement(), move)

local obbjee = createObject(2942 , 2 , 2 , 2)
addMoverObject(obbjee)

bindKey("m" , "down" , function()

    showCursor(not isCursorShowing())

end)