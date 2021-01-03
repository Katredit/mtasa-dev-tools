local sx , sy   = guiGetScreenSize()
local object    = createObject(1609 , 0 , 0 , 3)
objects = {}
objects['obje'] = object
local state     = 1
local lastClick = getTickCount()

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

-- for k , v in ipairs({"x" , "y" , "z"}) do 

--     for i = 1 , 3 do 

--         states[i].image[v[i]] = states[i].image["main"]

--     end

-- end

-- function addMoverObject(updateobject)
--     if object then return end
--     triggerServerEvent("addMoverObject" , root , updateobject)
-- end

-- function addMoveObject(updateobject)
--     object = updateobject



-- end
-- addEvent("addMoveObject" , true)
-- addEventHandler("addMoveObject" , root , addMoveObject)

setTimer(function()

    local x , y = getScreenFromWorldPosition(object.position)
    local ox , oy , oz = getElementPosition(object)
    oz = oz + 1
    
    if x and y then 
        
        for i=1, 4 do 

            local size = 22

            if isMouseInPosition(x , y , size , size) then

                if getKeyState("mouse1") and lastClick < getTickCount() then 
                    lastClick = getTickCount() + 200
                    state = i
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

                        dxDrawLine3D(ox , oy , oz , lx , ly , lz)
                        roundedRectangle(x , y , size , size , tocolor(0 , 0 , 0 , 100))
                        dxDrawImage(x + (size-16)/2 , y + (size-16)/2 , 16 , 16 , states[state].image.main)

                        if isMouseInPosition(x , y , size , size) and getKeyState("mouse1") and lastClick < getTickCount() then

                            lastCoordinate = "last"..string.upper(v:gsub("l" , ""))
                            lastMode = "setElementPosition(objects['obje'],"
                            lastCX, lastCY = getCursorPosition()
                            lastX , lastY , lastZ = ox , oy , oz-1

                            lastClick = getTickCount() + 200

                        end

                    end

                end

            end

        end

    end

end , 0 , 0)

bindKey("m" , "down" , function()
    showCursor(not isCursorShowing())
end)

function cursorMove( x , y )

    if not getKeyState("mouse1") or y == lastCY or not lastCY then return end

    local str = y < lastCY and "+" or "-"
    loadstring(lastCoordinate.." = "..lastCoordinate.." "..str.." 0.05")()
    loadstring(lastMode..lastX ..",".. lastY ..","..lastZ..")")()

    lastCY = y

end
addEventHandler( "onClientCursorMove", getRootElement(), cursorMove)