local thisActor = ...

--pouse時のメニューのアニメーションを取得
local pousemenuAnimation = scaleform.Actor.component_by_name(thisActor, "Animation")

--local hitpoint = scaleform.ContainerComponent.actor_by_name(rootAnimation, "hitpoint")
--local hitpointAnimation = scaleform.Actor.component_by_name(hitpoint, "animation")

-- http://help.autodesk.com/view/ScaleformStudio/ENU/?guid=__lua_ref_obj_scaleform_AnimationComponent_html
--animetionを止める
scaleform.AnimationComponent.stop(pousemenuAnimation)

--カスタムリスナーを作成
--外部でe.data.valueの値を1-36まで変えてあげることで、
--1-12までで1ダメージ、13-24までで2ダメージ、25-36までで3ダメージを表現
local customListener = scaleform.EventListener.create(customListener, function(e)
if e.name == "pause_menu" then
    scaleform.AnimationComponent.goto_frame(pousemenuAnimation, 13)
end
end );
----http://help.autodesk.com/view/ScaleformStudio/ENU/?guid=__lua_ref_ns_scaleform_EventListener_html
scaleform.EventListener.connect(customListener, thisActor,scaleform.EventTypes.Custom)