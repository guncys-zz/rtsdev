local thisActor = ...

--pouse時のメニューのアニメーションを取得
--local loadingAnimation = scaleform.Actor.component_by_name(thisActor, "Animation")
local totalTime = 0.0;
local dispatched = false;
local onloadflag = false;
--local hitpoint = scaleform.ContainerComponent.actor_by_name(rootAnimation, "hitpoint")
--local hitpointAnimation = scaleform.Actor.component_by_name(hitpoint, "animation")

-- http://help.autodesk.com/view/ScaleformStudio/ENU/?guid=__lua_ref_obj_scaleform_AnimationComponent_html
--animetionを止める
--scaleform.AnimationComponent.play(loadingAnimation)

--カスタムリスナーを作成
local enterFrameEventListener = scaleform.EventListener.create(enterFrameEventListener, function(e, thisListener)
    if onloadflag ~= true then  --1回目の呼び出しで初期化
        totalTime = 0.0
        dispatched = false
        onloadflag = true
    end
    
    local frameTime = scaleform.Stage.frame_time()
    totalTime = totalTime + frameTime
    print(totalTime)
    if totalTime > 2 then   --totaltimeが4秒を過ぎたら
        if dispatched ~= true then  --まだイベントをコールしていなかったら
            local evt = { eventId = scaleform.EventTypes.Custom, 
                        name = "change_level",
                        data = { } 
                    }
            scaleform.Stage.dispatch_event(evt)
            --change_levelってイベントをコールする
            print("change_levelをコールする")
            dispatched = true;
            onloadflag = false
        end
        scaleform.EventListener.disconnect(thisListener)
    end
end )

scaleform.EventListener.connect(enterFrameEventListener, thisActor, scaleform.EventTypes.EnterFrame)