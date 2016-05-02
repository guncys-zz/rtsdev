local thisActor = ...
--local thisActor = scaleform.Stage.actor_by_name_path("GameUI/hitpoint")

--hitpointのanimationを拾う
--子要素のhp1,hp2,hp3を拾って、そのanimationを保持
local hitpointAnimation = scaleform.Actor.component_by_name(thisActor, "Animation")

--local hitpoint = scaleform.ContainerComponent.actor_by_name(rootAnimation, "hitpoint")
--local hitpointAnimation = scaleform.Actor.component_by_name(hitpoint, "animation")

-- http://help.autodesk.com/view/ScaleformStudio/ENU/?guid=__lua_ref_obj_scaleform_AnimationComponent_html
--animetionを止める
scaleform.AnimationComponent.stop(hitpointAnimation)

--カスタムリスナーを作成
--外部でe.data.valueの値を1-36まで変えてあげることで、
--1-12までで1ダメージ、13-24までで2ダメージ、25-36までで3ダメージを表現
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