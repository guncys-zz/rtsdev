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

Project.MainMenu = Project.MainMenu or {}
local MainMenu = Project.MainMenu
MainMenu.custom_listener = MainMenu.custom_listener or nil


local start_time = 0

--[[
Mainmenuで鳴らすオーディオ用の関数群
-- Audio functions
--オーディオの数だけ自由に追加記述すればいい
--playとstopが対になっている
local function play_main_menu_ambient()
	if stingray.Wwise then
		stingray.Wwise.load_bank("content/audio/default")
		local wwise_world = stingray.Wwise.wwise_world(SimpleProject.world)
		stingray.WwiseWorld.trigger_event(wwise_world, "sfx_UI_music_start")
	end
end

local function stop_main_menu_ambient()
	if stingray.Wwise then
		stingray.Wwise.load_bank("content/audio/default")
		local wwise_world = stingray.Wwise.wwise_world(SimpleProject.world)
		stingray.WwiseWorld.stop_event(wwise_world, "sfx_UI_music_start")
	end
end

local function play_switch_game()
	if stingray.Wwise then
		stingray.Wwise.load_bank("content/audio/default")
		local wwise_world = stingray.Wwise.wwise_world(SimpleProject.world)
		stingray.WwiseWorld.trigger_event(wwise_world, "sfx_UI_music_switch_game")
	end
end

local function toggle_audio_on()
	if stingray.Wwise then
		stingray.Wwise.load_bank("content/audio/default")
		local wwise_world = stingray.Wwise.wwise_world(SimpleProject.world)
		stingray.WwiseWorld.trigger_event(wwise_world, "UI_Audio_Toggle_ON")
	end
end

local function toggle_audio_off()
	if stingray.Wwise then
		stingray.Wwise.load_bank("content/audio/default")
		local wwise_world = stingray.Wwise.wwise_world(SimpleProject.world)
		stingray.WwiseWorld.trigger_event(wwise_world, "UI_Audio_Toggle_OFF")
	end
end
]]--

--project.luaでlevel名がmainmenuの時に呼ばれる
--Mainmenuの呼び出し
function MainMenu.start()
	if stingray.Window then
		stingray.Window.set_show_cursor(true)
	end

	if scaleform then
	    scaleform.Stingray.load_project_and_scene("s2d_projects/ui.s2d/ui")
		--scaleform.Stingray.load_project("test_mainmenu.s2dproj", "s2d_projects/test_mainmenu")
		scaleform.Stage.set_view_scale_mode(1)
		--Register menu button mouse listener
                --メニュ―画面のボタンが押されたのを拾うリスナーを登録
		local custom_listener = MainMenu.custom_listener
		custom_listener = scaleform.EventListener.create(custom_listener, MainMenu.on_custom_event)
		MainMenu.custom_listener = custom_listener
		scaleform.EventListener.connect(custom_listener, scaleform.EventTypes.Custom)
	end

	local level = SimpleProject.level
	start_time = stingray.World.time(SimpleProject.world)
	-- make sure camera is at correct location
	local camera_unit = SimpleProject.camera_unit
	local camera = stingray.Unit.camera(camera_unit, 1)
	stingray.Unit.set_local_pose(camera_unit, 1, stingray.Matrix4x4.identity())
	stingray.Camera.set_local_pose(camera, camera_unit, stingray.Matrix4x4.identity())

	Appkit.manage_level_object(level, MainMenu, nil)
end

--Mainmenuのリリース（シャットダウン）
function MainMenu.shutdown(object)
	if scaleform then
		scaleform.EventListener.disconnect(MainMenu.custom_listener)
		scaleform.Stingray.unload_project()
	end

	MainMenu.evt_listener_handle = nil
	Appkit.unmanage_level_object(SimpleProject.level, MainMenu, nil)
	if stingray.Window then
		stingray.Window.set_show_cursor(false)
	end
end

--ボタンクリックイベントが発生したときの処理
MainMenu.action = nil
function MainMenu.on_custom_event(evt)
	if evt.name == "start_game" then
			MainMenu.action = "start"
	end
		if evt.name == "quit_game" then
			MainMenu.action = "exit"
	end
end

--MainMenu.updateで呼ばれる。mainmenuレベル時に実行したいことを記述しておく
local function perform_action()
	-- Load empty level
	if MainMenu.action == "start" then
		MainMenu.shutdown()
		SimpleProject.change_level(Project.level_names.testmap)    --testmapに遷移
	-- Exit the program
	elseif MainMenu.action == "exit" then
		stingray.Application.quit()
	end
	MainMenu.action = nil
end

-- [[Main Menu custom functionality]]--
function MainMenu.update(object, dt)
	if MainMenu.action == nil  then
		local time = stingray.World.time(SimpleProject.world)
		local p = stingray.Application.platform()
		if time - start_time > 1 then
			if Appkit.Util.is_pc() then
				if stingray.Keyboard.pressed(stingray.Keyboard.button_id("1")) then
					MainMenu.action = "start"
				elseif stingray.Keyboard.pressed(stingray.Keyboard.button_id("esc")) then
					MainMenu.action = "exit"
				end
			elseif p == stingray.Application.XB1 or p == stingray.Application.PS4 then 
				if stingray.Pad1.pressed(stingray.Pad1.button_id(Appkit.Util.plat(nil, "a", nil, "cross"))) then
    				MainMenu.action = "start"
    			elseif stingray.Pad1.pressed(stingray.Pad1.button_id(Appkit.Util.plat(nil, "b", nil, "circle"))) then
    				MainMenu.action = "exit"
    			end
    		end

		end
	end
	perform_action()
end

return MainMenu