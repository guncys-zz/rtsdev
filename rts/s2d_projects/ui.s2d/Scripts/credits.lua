local thisActor = ...
--local thisActor = scaleform.Stage.actor_by_name_path("GameUI/hitpoint")
local dispatched = false;
local bgmcall = false;

local creditAnimation = scaleform.Actor.component_by_name(thisActor, "Animation")
local SimpleProject = require 'core/appkit/lua/simple_project'


local enterFrameEventListener = scaleform.EventListener.create(enterFrameEventListener, function(e, thisListener)
local current_frame = scaleform.AnimationComponent.current_frame(creditAnimation)

if bgmcall == false then
    --stingray.Wwise.load_bank("content/audio/default")
    local wwise_world = stingray.Wwise.wwise_world(SimpleProject.world)
    stingray.WwiseWorld.trigger_event(wwise_world, "Play_BGM_StaffRoll")
    bgmcall = true
end
print("フレーﾑ数（5760目標）" .. current_frame)

--print(current_frame)
if current_frame == 5760 then
    if dispatched ~= true then  --まだイベントをコールしていなかったら
        if stingray.Keyboard.pressed(stingray.Keyboard.button_id("space")) then
            local evt = { eventId = scaleform.EventTypes.Custom,
                      name = "go_to_top",
                      data = {} }
            scaleform.Stage.dispatch_event(evt)
            print("タイトルに戻るイベントを発生")
            dispatched = true
        end
    end
end 
end)

scaleform.EventListener.connect(enterFrameEventListener, thisActor, scaleform.EventTypes.EnterFrame)