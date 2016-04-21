require 'core/appkit/lua/class'
require 'core/appkit/lua/app'

local damage_anim = 0

UI = UI or{}

--ダメージアニメーションの制御
function PlayUI.damage(hp)
    local event = { --eventは関数内localではなく、このファイル内でアクセスできるようにする
		eventId = scaleform.EventTypes.Custom,
		name = nil,
		data = nil
	}
	if damage_anim < 12 then
	    event.name = "damage_1"
    elseif damage_anim < 24 then
        event.name = "damage_2"
    elseif damage_anim < 36 then
        event.name = "damage_3"
    end
	
	local i = 1
	while i < 12 do
	    damage_anim = damage_anim + 1
	    event.data =  {value = damage_anim}
	    scaleform.Stage.dispatch_event(event)
	    i = i + 1
    end
end