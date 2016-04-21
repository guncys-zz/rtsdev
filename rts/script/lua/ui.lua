require 'core/appkit/lua/class'
require 'core/appkit/lua/app'

local damage_anim = 1

UI = UI or{}

--ダメージアニメーションの制御
function PlayUI.damage(hp)
    local event = { --eventは関数内localではなく、このファイル内でアクセスできるようにする
		eventId = scaleform.EventTypes.Custom,
		name = nil,
		data = nil
	}
	event.name = "damage"
	
	local i = 0
	while i < 12 do
	    damage_anim = damage_anim + 1
	    event.data =  {value = damage_anim}
	    scaleform.Stage.dispatch_event(event)
	    i = i + 1
    end
end

function PlayUI.move_player(position)
    --プレイヤーの現在地から、UI上での長さでどのあたりかを求めて、そこにプレイヤーキャラを移動
end

function PlayUI.move_cat(position)
    --猫の仮の現在地から、UI上での長さでどのあたりかを求めて、そこに猫キャラを移動
end

return UI