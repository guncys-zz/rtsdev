local thisActor = ...
--local thisActor = scaleform.Stage.actor_by_name_path("GameUI/hitpoint")
local dispatched = false;

local creditAnimation = scaleform.Actor.component_by_name(thisActor, "Animation")
local SimpleProject = require 'core/appkit/lua/simple_project'


local enterFrameEventListener = scaleform.EventListener.create(enterFrameEventListener, function(e, thisListener)
local current_frame = scaleform.AnimationComponent.current_frame(creditAnimation)
--print(current_frame)
if current_frame == 5489 then
    if dispatched ~= true then  --まだイベントをコールしていなかったら
        print("spaceキーを押して！")
        if stingray.Keyboard.pressed(stingray.Keyboard.button_id("space")) then
            SimpleProject.change_level(Project.level_names.mainmenu)
            dispatched = true
        end
    end
end 
end)

scaleform.EventListener.connect(enterFrameEventListener, thisActor, scaleform.EventTypes.EnterFrame)