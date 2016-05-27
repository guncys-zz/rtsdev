require 'core/appkit/lua/class'
require 'core/appkit/lua/app'

local SimpleProject = require 'core/appkit/lua/simple_project'
local damage_anim = 10   --ダメージのアニメーション
local gauge_anim = 1    --ゲージのアニメーション   
local loding_flag = false   --1ステージごとにローディングされたかどうかを確認

UI = UI or{}

--UIのリセット
function UI.reset(hp, pos)
     local event = { --eventは関数内localではなく、このファイル内でアクセスできるようにする
		eventId = scaleform.EventTypes.Custom,
		name = nil,
		data = nil
	}
	--ダメージアニメーションの呼び出しイベント名登録
	event.name = "damage_reset"

    if hp == 9 then 
        damage_anim = 1
    elseif hp == 8 then 
        damage_anim = 12
    elseif hp == 7 then
        damage_anim = 24
    elseif hp == 6 then 
        damage_anim = 36
    elseif hp == 5 then
        damage_anim = 48
    elseif hp == 4 then 
        damage_anim = 60
    elseif hp == 3 then
        damage_anim = 72
    elseif hp == 2 then 
        damage_anim = 84
    elseif hp == 1 then
        damage_anim = 96
    elseif hp == 0 then 
        damage_anim = 108
    else
        damage_anim = 120
    end
    
    --ダメージ受けるのをUIアニメーションに伝達
    if damage_anim < 120 then
        event.data =  {value = damage_anim}
    	scaleform.Stage.dispatch_event(event)
	end
    
    --ゲージの呼び出しイベント名登録
	event.name = "update_gauge"
    --アニメーション処理
    --positionは1-1000の値を受け取る
    local gauge_pos = math.ceil(pos)   --切り上げ
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
	gauge_anim = gauge_pos
--	print(gauge_pos)
    event.data =  {value = gauge_anim}
    scaleform.Stage.dispatch_event(event)
    
	loding_flag = false
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

    if hp.HP == 9 then 
        damage_anim = 1
    elseif hp.HP == 8 then 
        damage_anim = 12
    elseif hp.HP == 7 then
        damage_anim = 24
    elseif hp.HP == 6 then 
        damage_anim = 36
    elseif hp.HP == 5 then
        damage_anim = 48
    elseif hp.HP == 4 then 
        damage_anim = 60
    elseif hp.HP == 3 then
        damage_anim = 72
    elseif hp.HP == 2 then 
        damage_anim = 84
    elseif hp.HP == 1 then
        damage_anim = 96
    elseif hp.HP == 0 then 
        damage_anim = 108
    else
        damage_anim = 120
    end
    
    --ダメージ受けるのをUIアニメーションに伝達
    if damage_anim < 120 then
        event.data =  {value = damage_anim}
    	scaleform.Stage.dispatch_event(event)
	end
	
    --[[
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
	    print("ダメージwhileの中")
    end
    ]]--
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
	
	--print(gauge_pos)
	while gauge_anim < gauge_pos do
        if gauge_anim >= 100 then   
	        break
        end
        gauge_anim = gauge_anim + 0.5
        event.data =  {value = gauge_anim}
	    scaleform.Stage.dispatch_event(event)
    end
end

function UI.gameOver()
    print("gameOver")
    print(SimpleProject.level_name)
    Appkit.set_pending_level_change(stingray.Application.flow_callback_context_level(), SimpleProject.level_name)

end

function UI.loading()
    if loding_flag ~= true then
        local loading = scaleform.Actor.load("Loading.s2dscene")	--Loding用のシーンをロード
    	--print("ローディングシーンに切り替え")
        -- Remove the main menu scene
        scaleform.Stage.remove_scene_by_index(1)
        -- Add the loading scene
        scaleform.Stage.add_scene(loading)
        loding_flag = true
    end

end

return UI