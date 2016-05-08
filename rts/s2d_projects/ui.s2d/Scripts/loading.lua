local thisActor = ...

--pouse時のメニューのアニメーションを取得
local loadingAnimation = scaleform.Actor.component_by_name(thisActor, "Animation")

--local hitpoint = scaleform.ContainerComponent.actor_by_name(rootAnimation, "hitpoint")
--local hitpointAnimation = scaleform.Actor.component_by_name(hitpoint, "animation")

-- http://help.autodesk.com/view/ScaleformStudio/ENU/?guid=__lua_ref_obj_scaleform_AnimationComponent_html
--animetionを止める
scaleform.AnimationComponent.play(loadingAnimation)

--カスタムリスナーを作成
local customListener = scaleform.EventListener.create(customListener, function(e)

end );
----http://help.autodesk.com/view/ScaleformStudio/ENU/?guid=__lua_ref_ns_scaleform_EventListener_html
scaleform.EventListener.connect(customListener, thisActor,scaleform.EventTypes.Custom)