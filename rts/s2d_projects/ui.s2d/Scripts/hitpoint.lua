local thisActor = ...
--local thisActor = scaleform.Stage.actor_by_name_path("GameUI/hitpoint")

--hitpointのanimationコンポーネントを拾う
local hitpointAnimation = scaleform.Actor.component_by_name(thisActor, "Animation")

-- http://help.autodesk.com/view/ScaleformStudio/ENU/?guid=__lua_ref_obj_scaleform_AnimationComponent_html
--animetionを止める
scaleform.AnimationComponent.stop(hitpointAnimation)

--カスタムリスナーを作成
--外部でe.data.valueの値を変えてあげることで、アニメーションのフレームを制御
--12フレームで1ダメージを表現
local customListener = scaleform.EventListener.create(customListener, function(e)
if e.name == "damage" then
    scaleform.AnimationComponent.goto_frame(hitpointAnimation, e.data.value)
    scaleform.AnimationComponent.play(hitpointAnimation)
elseif e.name == "damage_reset" then 
     scaleform.AnimationComponent.goto_frame(hitpointAnimation, e.data.value)
end
end );
----http://help.autodesk.com/view/ScaleformStudio/ENU/?guid=__lua_ref_ns_scaleform_EventListener_html
scaleform.EventListener.connect(customListener, thisActor,scaleform.EventTypes.Custom)