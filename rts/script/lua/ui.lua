require 'core/appkit/lua/class'
require 'core/appkit/lua/app'

local damage_anim = 0

PlayUI = PlayUI or{}

--ダメージアニメーションの制御
function PlayUI.damage(hp)
    local event = { --eventは関数内localではなく、このファイル内でアクセスできるようにする
		eventId = scaleform.EventTypes.Custom,
		name = nil,
		data = nil
	}
	--ダメージアニメーションの呼び出しイベント名登録
	event.name = "damage"
--	print(hp)
    
    --アニメーション処理
	local i = 0
	while i < 12 do --12フレームで1ハートが減る
	    if damage_anim >= 36 then   --メインルーチンで,Damage処理が連続しておきる問題がある。これは必要以上にアニメーションしないための処置
	        break
        end
	    damage_anim = damage_anim + 1
	    event.data =  {value = damage_anim}
	    scaleform.Stage.dispatch_event(event)
	    i = i + 1
    end
--    print(damage_anim)
end

function PlayUI.move_player(position)
    --プレイヤーの現在地から、UI上での長さでどのあたりかを求めて、そこにプレイヤーキャラを移動
end

function PlayUI.move_cat(position)
    --猫の仮の現在地から、UI上での長さでどのあたりかを求めて、そこに猫キャラを移動
end

return PlayUI