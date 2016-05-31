--[[
	Customized functions for controlling what happens for a particular loaded level.
	These classes should define any  of

	init(level)
	start(level)
	update(level, dt)
	shutdown(level)
	render(level)
]]--

local Util = require 'core/appkit/lua/util'
local SimpleProject = require 'core/appkit/lua/simple_project'

Project.Ending = Project.Ending or {}
local Ending = Project.Ending
Ending.custom_listener = Ending.custom_listener or nil

local start_time = 0

function Ending.start()
	if stingray.Window then
		stingray.Window.set_show_cursor(true)
	end
	if scaleform then
	    scaleform.Stingray.load_project_and_scene("s2d_projects/ui.s2d/ui") --Loads a Scaleform Studio project. 
		
		 --画面レンダの振る舞いの設定
        --http://help.autodesk.com/view/ScaleformStudio/ENU/?guid=__scaleform_studio_help_getting_started_interface_overview_project_panel_html
		scaleform.Stage.set_view_scale_mode(2)  --Sets the current scale mode for the stage

        local loading = scaleform.Actor.load("Empty.s2dscene")
	    -- Remove the main menu scene
        scaleform.Stage.remove_scene_by_index(1)
        -- Add the loading scene
        scaleform.Stage.add_scene(loading)
		
		local custom_listener = scaleform.EventListener.create(custom_listener, Ending.on_custom_event)   --Creates an event listener.
		Ending.custom_listener = custom_listener  --ローカルオブジェクトをクラスオブジェクトにコピー
		scaleform.EventListener.connect(custom_listener, scaleform.EventTypes.Custom)   --Connects the event listener to stage events of the input type

	end

	--local level = SimpleProject.level
	start_time = stingray.World.time(SimpleProject.world)
	-- make sure camera is at correct location
	local camera_unit = SimpleProject.camera_unit
	local camera = stingray.Unit.camera(camera_unit, 1)
	stingray.Unit.set_local_pose(camera_unit, 1, stingray.Matrix4x4.identity())
	stingray.Camera.set_local_pose(camera, camera_unit, stingray.Matrix4x4.identity())

	Appkit.manage_level_object(SimpleProject.level, Ending, nil) -- Managed objects receive type.update(object, dt) and type.shutdown(object) calls
end

--Mainmenuのリリース（シャットダウン）
function Ending.shutdown(object)
	if scaleform then
		scaleform.EventListener.disconnect(Ending.custom_listener)--Disconnects all connections to the event listener. 
		scaleform.Stingray.unload_project()--Unloads a Scaleform Studio project. 
	end

	Ending.evt_listener_handle = nil
	Appkit.unmanage_level_object(SimpleProject.level, Ending, nil)-- Unmanaged objects receive type.update(object, dt) and type.shutdown(object) calls
	if stingray.Window then
		stingray.Window.set_show_cursor(false)
	end
end

--カスタムイベントが発生したときの処理
Ending.action = nil
function Ending.on_custom_event(evt)
	if evt.name == "change_level" then
        Ending.action = "change_level"
    elseif evt.name == "go_to_top" then
        Ending.action = "go_to_top"
    end
end

local function perform_action()
	if Ending.action == "change_level" then
    SimpleProject.change_level(Project.level_names.stage1)
elseif Ending.action == "go_to_top" then
    --print("イベントに入った")
        SimpleProject.change_level(Project.level_names.mainmenu)
     --   print("イベントを実行した")
    end
	Ending.action = nil
end

-- [[Main Menu custom functionality]]--
function Ending.update(object, dt)
	perform_action()
end

return Ending