local component = component or require(component)

local fs

for file_system in component.list("filesystem") do
    if component.invoke(file_system, "exists", "/rud.os") then
        fs = filesystem
    end
end
if not fs then
    error("/rud.os not detected!")
end

local function load_file(file_path)
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

    return load(buffer, "=" .. file_path)
    
end

kernel = load_file("/krn.lua")
kernel()