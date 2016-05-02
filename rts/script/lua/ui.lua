require 'core/appkit/lua/class'
require 'core/appkit/lua/app'

local damage_anim = 0   --ダメージのアニメーション
local gauge_anim = 1    --ゲージのアニメーション   
local hp_res = 3    --リセット用のhp情報
local pos_res = 1   --リセット用のpos情報

UI = UI or{}

--UIのリセット
function UI.reset()
     local event = { --eventは関数内localではなく、このファイル内でアクセスできるようにする
		eventId = scaleform.EventTypes.Custom,
		name = nil,
		data = nil
	}
	--ダメージアニメーションの呼び出しイベント名登録
	event.name = "damage"

    if hp_res == 2 then 
        damage_anim = 0
    elseif hp_res == 1 then 
        damage_anim = 12
    elseif hp_res == 0 then
        damage_anim = 24
    else
        damage_anim = 36
    end
    
    print("reset HP with" .. hp_res)
    print("reset Pos with" .. pos_res)
    --アニメーション処理
    if hp_res ~= 3 then
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
    end
    
    --ダメージアニメーションの呼び出しイベント名登録
	event.name = "update_gauge"
    
    --アニメーション処理
    --positionは1-1000の値を受け取る
    local gauge_pos = math.ceil(pos_res)   --切り上げ
    gauge_pos = gauge_pos / 1000    --1~1000を0.0~1.0で表現   
    --1-100に変換
    
    if gauge_pos * 100 >= 1 then
        gauge_pos = gauge_pos * 100
    else
        gauge_pos = 1      
    end
	
	while gauge_anim < gauge_pos do
        if gauge_anim >= 100 then   
	        break
        end
        gauge_anim = gauge_anim + 0.5
        event.data =  {value = gauge_anim}
	    scaleform.Stage.dispatch_event(event)
    end
end

--ダメージアニメーションの制御
function UI.damage(hp)
    local event = { --eventは関数内localではなく、このファイル内でアクセスできるようにする
		eventId = scaleform.EventTypes.Custom,
		name = nil,
		data = nil
	}
	--ダメージアニメーションの呼び出しイベント名登録
	event.name = "damage"

    if hp.HP == 2 then 
        damage_anim = 0
    elseif hp.HP == 1 then 
        damage_anim = 12
    elseif hp.HP == 0 then
        damage_anim = 24
    else
        damage_anim = 36
    end
    
    --レベルまたぐ用のHP情報を保管
    hp_res = hp.HP
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

function UI.gauge_update(pos)  --positionにはプレイヤーのY方向の位置が入る
    --プレイヤーの現在地から、UI上での長さでどのあたりかを求めて、アニメーションを制御
     local event = { --eventは関数内localではなく、このファイル内でアクセスできるようにする
		eventId = scaleform.EventTypes.Custom,
		name = nil,
		data = nil
	}
	--ダメージアニメーションの呼び出しイベント名登録
	event.name = "update_gauge"
    
    --アニメーション処理
    --positionは1-1000の値を受け取る
    local gauge_pos = math.ceil(pos.Position)   --切り上げ
    gauge_pos = gauge_pos / 1000    --1~1000を0.0~1.0で表現   
    --1-100に変換
    
    if gauge_pos * 100 >= 1 then
        gauge_pos = gauge_pos * 100
    else
        gauge_pos = 1      
    end
    --gauge_animが少数型になっているのが、メモリリークの元になっているっぽい
	--gauge_anim = gauge_anim + 1
	
	--レベルまたぐ用にpos情報を保管
	pos_res = pos.Position
	
	while gauge_anim < gauge_pos do
        if gauge_anim >= 100 then   
	        break
        end
        gauge_anim = gauge_anim + 0.5
        event.data =  {value = gauge_anim}
	    scaleform.Stage.dispatch_event(event)
    end
end

function UI.show_pouse_menu()
    local event = { --eventは関数内localではなく、このファイル内でアクセスできるようにする
    		eventId = scaleform.EventTypes.Custom,
    		name = nil,
    		data = nil
    	}
    	--ダメージアニメーションの呼び出しイベント名登録
    event.name = "pause_menu"
    
    local i = 0
    while i <= 13 do
        i = i + 1
        event.data = {value = i}
        scaleform.Stage.dispatch_event(event)
    end
end


return UI