local thisActor = ...
--local thisActor = scaleform.Stage.actor_by_name_path("GameUI/hitpoint")
local dispatched = false;
--hitpointのanimationを拾う
--子要素のhp1,hp2,hp3を拾って、そのanimationを保持
local logoAnimation = scaleform.Actor.component_by_name(thisActor, "Animation")

--local hitpoint = scaleform.ContainerComponent.actor_by_name(rootAnimation, "hitpoint")
--local hitpointAnimation = scaleform.Actor.component_by_name(hitpoint, "animation")

-- http://help.autodesk.com/view/ScaleformStudio/ENU/?guid=__lua_ref_obj_scaleform_AnimationComponent_html
--animetionを止める
--scaleform.AnimationComponent.stop(hitpointAnimation)
print("ロゴのファイルにアクセスしている")

local enterFrameEventListener = scaleform.EventListener.create(enterFrameEventListener, function(e, thisListener)
local current_frame = scaleform.AnimationComponent.current_frame(logoAnimation)
print(current_frame)
if current_frame == 89 then
    if dispatched ~= true then  --まだイベントをコールしていなかったら
        local evt = { eventId = scaleform.EventTypes.Custom, 
                      name = "start_title",
                      data = { } 
                     }
        --scaleform.Stage.dispatch_event(evt)
        print("タイトルを呼ぶイベントを走らせる")
        local loading = scaleform.Actor.load("Mainmenu.s2dscene")
	    -- Remove the main menu scene
        scaleform.Stage.remove_scene_by_index(1)
        -- Add the loading scene
        scaleform.Stage.add_scene(loading)
        --change_levelってイベントをコールする
        --print("change_levelをコールする")
        dispatched = true
        end
end
end )

scaleform.EventListener.connect(enterFrameEventListener, thisActor, scaleform.EventTypes.EnterFrame)