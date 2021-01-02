local sx , sy = guiGetScreenSize()


function addMoverObject(object)
    triggerServerEvent("addMoverObject" , root , object)
end

function addMoveObject(object)
    
end
addEvent("addMoveObject" , true)
addEventHandler("addMoveObject" , root , addMoveObject)