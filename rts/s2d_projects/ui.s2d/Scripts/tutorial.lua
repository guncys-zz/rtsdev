local thisActor = ...
--local thisActor = scaleform.Stage.actor_by_name_path("GameUI/hitpoint")

--gaugeのAnimationを拾う
local tutorialAnimation = scaleform.Actor.component_by_name(thisActor, "Animation")
-- http://help.autodesk.com/view/ScaleformStudio/ENU/?guid=__lua_ref_obj_scaleform_AnimationComponent_html
--animetionを止める
scaleform.AnimationComponent.stop(tutorialAnimation)

--カスタムリスナーを作成
--外部でe.data.valueの値を1-100まで変えてあげることで、
--gaugeバーの動きを制御
local customListener = scaleform.EventListener.create(customListener, function(e)
if e.name == "tutorial" then
    if e.data.value == "Jump_00" then
        local container = scaleform.Actor.container(thisActor);
        scaleform.AnimationComponent.play_label(container, "jump00_btn");
    elseif e.data.value == "Jump_01" then
        local container = scaleform.Actor.container(thisActor);
        scaleform.AnimationComponent.play_label(container, "jump01_btn");
    elseif e.data.value == "Roll_00" then
        local container = scaleform.Actor.container(thisActor);
        scaleform.AnimationComponent.play_label(container, "roll_btn");
        --scaleform.AnimationComponent.goto_frame(gaugeAnimation, e.data.value)
    end

end
end );
----http://help.autodesk.com/view/ScaleformStudio/ENU/?guid=__lua_ref_ns_scaleform_EventListener_html
scaleform.EventListener.connect(customListener, thisActor,scaleform.EventTypes.Custom)