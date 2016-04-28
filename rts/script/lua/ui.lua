require 'core/appkit/lua/class'
require 'core/appkit/lua/app'

local damage_anim = 0   --ダメージのアニメーション
local gauge_anim = 1    --ゲージのアニメーション   

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

function PlayUI.gauge_update(pos)  --positionにはプレイヤーのY方向の位置が入る
    --プレイヤーの現在地から、UI上での長さでどのあたりかを求めて、アニメーションを制御
     local event = { --eventは関数内localではなく、このファイル内でアクセスできるようにする
		eventId = scaleform.EventTypes.Custom,
		name = nil,
		data = nil
	}
	--ダメージアニメーションの呼び出しイベント名登録
	event.name = "update_gauge"
--	print(hp)
    
    --アニメーション処理
    --positionは1-1000の値を受け取る
    --1-100に変換
	gauge_anim = pos.Position / 10
	--gauge_anim = gauge_anim + 1
	gauge_anim = math.ceil(gauge_anim)
--	print(gauge_anim)
	if gauge_anim <= 100 then
	    event.data =  {value = gauge_anim}
	    scaleform.Stage.dispatch_event(event)
    end
end

return PlayUI