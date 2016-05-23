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

Project.Opening = Project.Opening or {}
local Opening = Project.Opening
Opening.custom_listener = Opening.custom_listener or nil

local start_time = 0

function Opening.start()
	if stingray.Window then
		stingray.Window.set_show_cursor(true)
	end
	if scaleform then
	    scaleform.Stingray.load_project_and_scene("s2d_projects/ui.s2d/ui") --Loads a Scaleform Studio project. 
		
		 --画面レンダの振る舞いの設定
        --http://help.autodesk.com/view/ScaleformStudio/ENU/?guid=__scaleform_studio_help_getting_started_interface_overview_project_panel_html
		scaleform.Stage.set_view_scale_mode(2)  --Sets the current scale mode for the stage

        local loading = scaleform.Actor.load("Opening.s2dscene")
	    -- Remove the main menu scene
        scaleform.Stage.remove_scene_by_index(1)
        -- Add the loading scene
        scaleform.Stage.add_scene(loading)
		
		local custom_listener = scaleform.EventListener.create(custom_listener, Opening.on_custom_event)   --Creates an event listener.
		Opening.custom_listener = custom_listener  --ローカルオブジェクトをクラスオブジェクトにコピー
		scaleform.EventListener.connect(custom_listener, scaleform.EventTypes.Custom)   --Connects the event listener to stage events of the input type

	end

	--local level = SimpleProject.level
	start_time = stingray.World.time(SimpleProject.world)
	-- make sure camera is at correct location
	local camera_unit = SimpleProject.camera_unit
	local camera = stingray.Unit.camera(camera_unit, 1)
	stingray.Unit.set_local_pose(camera_unit, 1, stingray.Matrix4x4.identity())
	stingray.Camera.set_local_pose(camera, camera_unit, stingray.Matrix4x4.identity())

	Appkit.manage_level_object(SimpleProject.level, Opening, nil) -- Managed objects receive type.update(object, dt) and type.shutdown(object) calls
end

--Mainmenuのリリース（シャットダウン）
function Opening.shutdown(object)
	if scaleform then
		scaleform.EventListener.disconnect(Opening.custom_listener)--Disconnects all connections to the event listener. 
		scaleform.Stingray.unload_project()--Unloads a Scaleform Studio project. 
	end

	Opening.evt_listener_handle = nil
	Appkit.unmanage_level_object(SimpleProject.level, Opening, nil)-- Unmanaged objects receive type.update(object, dt) and type.shutdown(object) calls
	if stingray.Window then
		stingray.Window.set_show_cursor(false)
	end
end

--カスタムイベントが発生したときの処理
Opening.action = nil
function Opening.on_custom_event(evt)
	if evt.name == "change_level" then
        Opening.action = "change_level"
    end
end

local function perform_action()
	if Opening.action == "change_level" then
    SimpleProject.change_level(Project.level_names.stage1)
    end
	Opening.action = nil
end

-- [[Main Menu custom functionality]]--
function Opening.update(object, dt)
	perform_action()
end

return Opening