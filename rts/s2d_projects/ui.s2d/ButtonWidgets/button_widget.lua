--
-- IMPORTANT: This script resource may be attached to all Button widgets created by the Widget Creator panel.
--            If modifications are required, then first copy this file to a unique path and fix all necessary
--            script components' resource paths.
--

local thisActor = ...;
scaleform.Actor.set_mouse_enabled_for_children(thisActor, false);

-- Helper function to set the label text of the button. 
--  setLabelText("new button label");
local setLabelText = function(labelText)
    local container = scaleform.Actor.container(thisActor);
    local labelActor = scaleform.ContainerComponent.actor_by_name(container, "label");
    if labelActor ~= nil then
        scaleform.TextComponent.set_text(scaleform.Actor.component_by_index(labelActor, 1) , labelText);
    end
end

-- Helper function to get the label text of the button. 
--  local btnLabel = getLabelText();
local getLabelText = function()
    local container = scaleform.Actor.container(thisActor);
    local labelActor = scaleform.ContainerComponent.actor_by_name(container, "label");
    if labelActor ~= nil then
        return scaleform.TextComponent.text(scaleform.Actor.component_by_index(labelActor, 1));
    end
end

local emitEvent = function(func, param)
    local comp = scaleform.Actor.component_by_name(thisActor, "WidgetHandler");
    if comp ~= nil then
        local handlerObject = scaleform.ScriptComponent.script_results(comp);
        if handlerObject ~= nil then
            if handlerObject[func] ~= nil then
                if (param) then
                    handlerObject[func](param);
                else
                    handlerObject[func]();
                end
            end
        end
    end
end

mouseDownEventListener = scaleform.EventListener.create(mouseDownEventListener, function(e)
    local container = scaleform.Actor.container(thisActor);
    scaleform.AnimationComponent.play_label(container, "press");
    emitEvent("pressed");
    emitEvent("stateChanged", "press");
end )

mouseUpEventListener = scaleform.EventListener.create(mouseUpEventListener, function(e)
    local container = scaleform.Actor.container(thisActor);
    scaleform.AnimationComponent.play_label(container, "over");
    emitEvent("clicked");
    emitEvent("stateChanged", "over");
end )

mouseOverEventListener = scaleform.EventListener.create(mouseOverEventListener, function(e)
    local container = scaleform.Actor.container(thisActor);
    scaleform.AnimationComponent.play_label(container, "over");
    emitEvent("stateChanged", "over");
end )

mouseOutEventListener = scaleform.EventListener.create(mouseOutEventListener, function(e)
    local container = scaleform.Actor.container(thisActor);
    scaleform.AnimationComponent.play_label(container, "normal");
    emitEvent("stateChanged", "normal");
end )

mouseReleaseOutsideEventListener = scaleform.EventListener.create(mouseReleaseOutsideEventListener, function(e)
    local container = scaleform.Actor.container(thisActor);
    scaleform.AnimationComponent.play_label(container, "normal");
    emitEvent("releasedOutside");
    emitEvent("stateChanged", "normal");
end )

scaleform.EventListener.connect(mouseDownEventListener, thisActor, scaleform.EventTypes.MouseDown)
scaleform.EventListener.connect(mouseUpEventListener, thisActor, scaleform.EventTypes.MouseUp)
scaleform.EventListener.connect(mouseOverEventListener, thisActor, scaleform.EventTypes.MouseOver)
scaleform.EventListener.connect(mouseOutEventListener, thisActor, scaleform.EventTypes.MouseOut)
scaleform.EventListener.connect(mouseReleaseOutsideEventListener, thisActor, scaleform.EventTypes.MouseUpOutside)

-- Save the methods below in this script component to use them from elsewhere
local exports = {
    setLabelText = setLabelText;
    getLabelText = getLabelText;
}
return exports;
