local thisActor = ...

--pouse時のメニューのアニメーションを取得
local pausemenuAnimation = scaleform.Actor.component_by_name(thisActor, "Animation")

--local hitpoint = scaleform.ContainerComponent.actor_by_name(rootAnimation, "hitpoint")
--local hitpointAnimation = scaleform.Actor.component_by_name(hitpoint, "animation")

-- http://help.autodesk.com/view/ScaleformStudio/ENU/?guid=__lua_ref_obj_scaleform_AnimationComponent_html
--animetionを止める
scaleform.AnimationComponent.stop(pausemenuAnimation)

--カスタムリスナーを作成
local customListener = scaleform.EventListener.create(customListener, function(e)
if e.name == "show_menu" then
    scaleform.AnimationComponent.goto_frame(pausemenuAnimation, e.data.value)--e.data.value)
    scaleform.AnimationComponent.play(pausemenuAnimation)
elseif e.name == "hide_menu" then
    scaleform.AnimationComponent.goto_frame(pausemenuAnimation, e.data.value)--e.data.value)
    scaleform.AnimationComponent.play(pausemenuAnimation)
end
end );
----http://help.autodesk.com/view/ScaleformStudio/ENU/?guid=__lua_ref_ns_scaleform_EventListener_html
scaleform.EventListener.connect(customListener, thisActor,scaleform.EventTypes.Custom)