require 'core/appkit/lua/class'
require 'core/appkit/lua/app'

local Vector3 = stingray.Vector3
local Quaternion = stingray.Quaternion

Tools = Tools or {}

function Tools.Load_csv(t)
    
    print("csv path: "..t.Path)

    local file = io.open(t.Path)
    if file == nil then
        print ("Error open csv file")
        return 
    end
    
    for line in file:lines() do
        print("start spawn: "..line)
        name, px, py, pz, rx, ry, rz = string.match(line, "(.-)%,(.-)%,(.-)%,(.-)%,(.-)%,(.-)%,(.+)")
        Tools.Spawn(name, Vector3(px, py, pz), Quaternion.from_euler_angles_xyz(rx, ry, rz))
    end
    
end

function Tools.Spawn(name, position, rotation)
    local SimpleProject = require 'core/appkit/lua/simple_project'
    local world = SimpleProject.world
        
    stingray.World.spawn_unit(world, name, position, rotation)
end