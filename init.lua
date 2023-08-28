component = component or require(component)

DBG = true
local _, debug = xpcall(
    function()
        local result
        for dbg in component.list("debug") do
            result = dbg
        end
        return result
    end, 
    function()
        error("NO DEBUGCARD!!!!!!!") 
        --DBG = false 
    end
)

function debug_say(msg)
    if not DBG then 
        return "not debug"
        --error("NOT DBG")
    end

    succes, output = component.invoke(debug, "runCommand", "/say "..msg)

    if succes == 0 then
        error(output)
    end
end

local fs

for file_system in component.list("filesystem") do
    if component.invoke(file_system, "exists", "/rud.os") then
        fs = file_system
    end
end
if not fs then
    error("/rud.os not detected!")
end


local function read_file(file_path)
    debug_say("reading file "..file_path)
    local file, reason = component.invoke(fs, "open", file_path, "r")
    if not file then
        error(reason)
    end

    local buffer = ""

    repeat
        local data, reason = component.invoke(fs, "read", file, math.maxinteger or math.huge)

        if not data and reason then
            error(reason)
        end

        buffer = buffer..(data or "")
    
    until not data

    return buffer
end

local function load_file(file_path)
    debug_say("loading file "..file_path)
    return load(read_file(file_path), "=" .. file_path)
end

PATH = "/mods/"
local loadedModules = {}
function require(module_name)
    if loadedModules[module_name] then
        return loadedModules[module_name]
    end

    local module = load_file(PATH..module_name..".lua")()
    
    loadedModules[module_name] = module

    return module
end

debug_say("ok?")
load_file("/prog/login.lua")