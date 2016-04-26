require 'core/appkit/lua/class'
require 'core/appkit/lua/app'

local Vector3 = stingray.Vector3
local Quaternion = stingray.Quaternion

Tools = Tools or {}

-- spawnしたオブジェクトをテーブル格納
unit_objects = {}

function Tools.Load_csv(t)
    
    print("csv path: "..t.Path)

    local file = io.open(t.Path)
    if file == nil then
        print ("Error open csv file")
        return 
    end
    
    unit_objects = {}
    for line in file:lines() do
        print("start spawn: "..line)
        local name, px, py, pz, rx, ry, rz = string.match(line, "(.-)%,(.-)%,(.-)%,(.-)%,(.-)%,(.-)%,(.+)")
        
        Tools.Spawn(name, Vector3(px, py, pz), Quaternion.from_euler_angles_xyz(rx, ry, rz))
    end
    
end

function Tools.Destroy_units_csv(t)
    local SimpleProject = require 'core/appkit/lua/simple_project'
    local world = SimpleProject.world
    
    for key, unit in ipairs(unit_objects) do
        
        -- csvで指定したunitを削除
        stingray.World.destroy_unit(world, unit)
    end
end
    
function Tools.Spawn(name, position, rotation)
    local SimpleProject = require 'core/appkit/lua/simple_project'
    local world = SimpleProject.world
        
    local unit = stingray.World.spawn_unit(world, name, position, rotation)
    table.insert(unit_objects, unit)
end


function Tools.IsBlocker(t)
    
    r = {}
    
    -- 返り値のテーブル
    r["Bool"] = false
    
    -- IsBlockerがTrueか判定
    if stingray.Unit.get_data(t.Unit, "IsBlocker") then
        r["Bool"] = true
        
    end
    
    return r
    
end


