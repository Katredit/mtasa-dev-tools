functions = {}

objects = setmetatable({} , functions)

function addMoverObject(object)
    
end
addEvent("addMoverObject" , true)
addEventHandler("addMoverObject" , root , addMoverObject)

local ornek = createObject(1608 , 0 , 0 , 3)
triggerClientEvent(root , "addMoveObject" , root , ornek)