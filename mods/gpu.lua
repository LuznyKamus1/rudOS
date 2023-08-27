gpu = component.getPrimary("gpu")

local cursor_X, cursor_Y

function setBackgroundAndForeground(background, foreground)
    component.invoke(gpu, "setBackground", background)
    component.invoke(gpu, "setForeground", foreground)
    
end

function setResolution(x, y)
    component.invoke(gpu, "setResolution", x, y)       
end

function getMaxRes()
    return component.invoke(gpu, "maxResolution")
    
end

function clear()
    component.invoke(gpu, "fill", 1, 1, getMaxRes(), " ")
end

function init()
    component.invoke(gpu, "bind", component.getPrimary("Screen"))
    
    setBacgroundAndForeground(0xFFFFFF, 0x000000)
    
    setResolution(getMaxRes())

    clear()

    cursor_X, cursor_Y = 0, 0
end

function move_cursor(amnt) 
    local maxResX, maxResY = getMaxRes()
    
    while cursor_x + amnt > maxResX do
        cursor_x = 0
        if cursor_y + 1 > maxResY do
            clear()
            cursor_y, cursor_x = 0, 0
        else
            cursor_y = cursor_y +1
        end
        amnt = amnt-1
    end
end

function say(msg)
    component.invoke(gpu, "set", cursor_x, cursor_y, msg)
    move_cursor(#msg)
end