local thisActor = ...
--local thisActor = scaleform.Stage.actor_by_name_path("GameUI/hitpoint")

--gaugeのAnimationを拾う
local gaugeAnimation = scaleform.Actor.component_by_name(thisActor, "Animation")
-- http://help.autodesk.com/view/ScaleformStudio/ENU/?guid=__lua_ref_obj_scaleform_AnimationComponent_html
--animetionを止める
scaleform.AnimationComponent.stop(gaugeAnimation)

--カスタムリスナーを作成
--外部でe.data.valueの値を1-100まで変えてあげることで、
--gaugeバーの動きを制御
local customListener = scaleform.EventListener.create(customListener, function(e)
if e.name == "update_gauge" then
    scaleform.AnimationComponent.goto_frame(gaugeAnimation, e.data.value)
end
end );
----http://help.autodesk.com/view/ScaleformStudio/ENU/?guid=__lua_ref_ns_scaleform_EventListener_html
scaleform.EventListener.connect(customListener, thisActor,scaleform.EventTypes.Custom)