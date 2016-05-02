local thisActor = ...

--pouse時のメニューのアニメーションを取得
local pousemenuAnimation = scaleform.Actor.component_by_name(thisActor, "Animation")

--local hitpoint = scaleform.ContainerComponent.actor_by_name(rootAnimation, "hitpoint")
--local hitpointAnimation = scaleform.Actor.component_by_name(hitpoint, "animation")

-- http://help.autodesk.com/view/ScaleformStudio/ENU/?guid=__lua_ref_obj_scaleform_AnimationComponent_html
--animetionを止める
scaleform.AnimationComponent.stop(pousemenuAnimation)

--カスタムリスナーを作成
local customListener = scaleform.EventListener.create(customListener, function(e)
if e.name == "show_menu" then
    local i = 1
    while i <= 13 do
        scaleform.AnimationComponent.goto_frame(pousemenuAnimation, i)--e.data.value)
        i = i + 1
    end
elseif e.name == "hide_menu" then
    local i = 13
    while i <= 24 do
        scaleform.AnimationComponent.goto_frame(pousemenuAnimation, i)--e.data.value)
        i = i + 1
    end
end
end );
----http://help.autodesk.com/view/ScaleformStudio/ENU/?guid=__lua_ref_ns_scaleform_EventListener_html
scaleform.EventListener.connect(customListener, thisActor,scaleform.EventTypes.Custom)