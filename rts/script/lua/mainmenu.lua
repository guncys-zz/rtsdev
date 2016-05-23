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

-- 決定音鳴らす
local function play_se_ok()
	if stingray.Wwise then
		stingray.Wwise.load_bank("content/audio/default")
		local wwise_world = stingray.Wwise.wwise_world(SimpleProject.world)
		stingray.WwiseWorld.trigger_event(wwise_world, "SE_UI_OK")
	end
end

--project.luaでlevel名がmainmenuの時に呼ばれる
--Mainmenuの呼び出し
function MainMenu.start()
	if stingray.Window then
		stingray.Window.set_show_cursor(true)
	end
    print("MainMenu.startを通った")
	if scaleform then
	    scaleform.Stingray.load_project_and_scene("s2d_projects/ui.s2d/ui") --Loads a Scaleform Studio project. 
		
		 --画面レンダの振る舞いの設定
        --http://help.autodesk.com/view/ScaleformStudio/ENU/?guid=__scaleform_studio_help_getting_started_interface_overview_project_panel_html
		scaleform.Stage.set_view_scale_mode(2)  --Sets the current scale mode for the stage
		--Enumeration values(scaleform.Stage.set_view_scale_mode)
        --ExactFit
        ----Scales the view so that the content bounds matches the viewport 
        ----while changing the viewport aspect ratio to match the content bounds ratio. 
        
        --NoBorder
        ----Scales the view so that the viewport fits inside the content bounds 
        ----while maintaining the viewport aspect ratio stage and clipping any content that is outside the viewport. 
         
        --NoScale
        ----The view does does not scale. 
        
        --ShowAll
        ----Scales the view so that the content bounds fits inside the viewport which maintaining the viewport aspect ratio.  
        --END:Enumeration values(scaleform.Stage.set_view_scale_mode)
        
        local loading = scaleform.Actor.load("GuncysLogo.s2dscene")
	    -- Remove the main menu scene
        scaleform.Stage.remove_scene_by_index(1)
        -- Add the loading scene
        scaleform.Stage.add_scene(loading)
        --Guncys Logo BGM
        
		--Register menu button mouse listener
        --メニュ―画面のボタンが押されたのを拾うリスナーを登録
        --MainMenu.on_custom_eventをリスナー関数として、ローカルなリスナーオブジェクトを作成
		local custom_listener = scaleform.EventListener.create(custom_listener, MainMenu.on_custom_event)   --Creates an event listener.
		MainMenu.custom_listener = custom_listener  --ローカルオブジェクトをクラスオブジェクトにコピー
		scaleform.EventListener.connect(custom_listener, scaleform.EventTypes.Custom)   --Connects the event listener to stage events of the input type
		--http://help.autodesk.com/view/ScaleformStudio/ENU/?guid=__lua_ref_enu_scaleform_EventTypes_htmlのイベントタイプの中から
		--カスタムイベントと紐づける
		--The event parameters for Custom event. 
        --The table passed as the data parameter can only contain specific types. For additional details please refer to the Events section in the Programming Guide.

	end

	--local level = SimpleProject.level
	start_time = stingray.World.time(SimpleProject.world)
	-- make sure camera is at correct location
	local camera_unit = SimpleProject.camera_unit
	local camera = stingray.Unit.camera(camera_unit, 1)
	stingray.Unit.set_local_pose(camera_unit, 1, stingray.Matrix4x4.identity())
	stingray.Camera.set_local_pose(camera, camera_unit, stingray.Matrix4x4.identity())

	Appkit.manage_level_object(SimpleProject.level, MainMenu, nil) -- Managed objects receive type.update(object, dt) and type.shutdown(object) calls
	--[[
        
        `Appkit` provides management for Editor Test Level and basic application objects,
        such as `Window`. It also exposes an interface to manage `World` objects, `Level`
        objects, and arbitrary game objects.
        
        The core usage of `Appkit` is to call `Appkit.setup_application` at Init time,
        then `Appkit.Update`, `Appkit.Render`, and `Appkit.Shutdown` from the respective
        engine Lua hooks.
        
        -------------------------------------------------------------------------------
        World Management
        -------------------------------------------------------------------------------
        
            -- Registers a `World` to be managed by Appkit. The `world` will update
            -- each frame, and render each frame with any enabled cameras and its
            -- shading environment. See the Appkit.WorldWrapper lua for information
            -- on using WorldWrapper objects.
            local world_wrapper = Appkit.manage_world(Project.world)
        
            -- Gets a managed `WorldWrapper` from the Appkit for a given `World`, or
            -- nil if the world is not managed by appkit.
            local world_wrapper = Appkit.get_managed_world(Project.world)
        
        -------------------------------------------------------------------------------
        Level Management
        -------------------------------------------------------------------------------
        
            -- Registers a `Level` to be managed by Appkit. The `Level` will update
            -- each frame. See the Appkit.LevelWrapper lua for information
            -- on using LevelWrapper objects.
            local Level_wrapper = Appkit.manage_Level(Project.Level)
        
            -- Gets a managed `LevelWrapper` from the Appkit for a given `Level`, or
            -- nil if the level is not managed by appkit.
            local level_wrapper = Appkit.get_managed_level(Project.level)
        
            -- Defines custom level unload and load functions for manaaged levels.
            -- This is used by the Appkit's Level / Change Level flow node and by
            -- Appkit.SimpleProject's change_level function. See the below Config
            -- section for default Appkit managed level load/unload behavior.
            Appkit.custom_unload_level_function = Project.unload_level
            Appkit.custom_load_level_function = Project.load_level
        
        ]]--
end

--Mainmenuのリリース（シャットダウン）
function MainMenu.shutdown(object)
	if scaleform then
		scaleform.EventListener.disconnect(MainMenu.custom_listener)--Disconnects all connections to the event listener. 
		scaleform.Stingray.unload_project()--Unloads a Scaleform Studio project. 
	end

	MainMenu.evt_listener_handle = nil
	Appkit.unmanage_level_object(SimpleProject.level, MainMenu, nil)-- Unmanaged objects receive type.update(object, dt) and type.shutdown(object) calls
	if stingray.Window then
		stingray.Window.set_show_cursor(false)
	end
end

--カスタムイベントが発生したときの処理
MainMenu.action = nil
function MainMenu.on_custom_event(evt)
	if evt.name == "start_game" then
			MainMenu.action = "start"
	end
	if evt.name == "quit_game" then
			MainMenu.action = "exit"
	end
	if evt.name == "stage1" then
			MainMenu.action = "to_stage1"
	end
	if evt.name == "stage2" then
			MainMenu.action = "to_stage2"
	end
	if evt.name == "stage3" then
			MainMenu.action = "to_stage3"
	end
	if evt.name == "stage4" then
			MainMenu.action = "to_stage4"
	end
	if evt.name == "ending" then
			MainMenu.action = "to_ending"
	end
	if evt.data == "start_title" then
	        MainMenu.action = "start_title"
    end
end

--MainMenu.updateで呼ばれる。mainmenuレベル時に実行したいことを記述しておく
local function perform_action()
	-- Load empty level
	if MainMenu.action == "start" then
	    play_se_ok() -- 決定音
	    --wait
		MainMenu.shutdown()
		SimpleProject.change_level(Project.level_names.test_cinematics)    --stage1に遷移
	-- Exit the program
	elseif MainMenu.action == "to_stage1" then
		MainMenu.shutdown()
		SimpleProject.change_level(Project.level_names.stage1)
	elseif MainMenu.action == "to_stage2" then
	    MainMenu.shutdown()
		SimpleProject.change_level(Project.level_names.stage2)
	elseif MainMenu.action == "to_stage3" then
	    MainMenu.shutdown()
		SimpleProject.change_level(Project.level_names.stage3)
	elseif MainMenu.action == "to_stage4" then
	    MainMenu.shutdown()
		SimpleProject.change_level(Project.level_names.stage4)
	elseif MainMenu.action == "to_ending" then
	  --  MainMenu.shutdown()
	--	SimpleProject.change_level(Project.level_names.stage1)
	elseif MainMenu.action == "exit" then
		stingray.Application.quit()
	elseif MainMenu.action == "start_title" then
	    print("スタートタイトルのアクションが走ってる")
	    local loading = scaleform.Actor.load("Mainmenu.s2dscene")
	    -- Remove the main menu scene
        scaleform.Stage.remove_scene_by_index(1)
        -- Add the loading scene
        scaleform.Stage.add_scene(loading)
        --title BGM
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
					--MainMenu.action = "start"
					local loading = scaleform.Actor.load("Loading.s2dscene")	--Loding用のシーンをロード
				--	print("cボタンが押されたよ！！！！！")
            	    -- Remove the main menu scene
                    scaleform.Stage.remove_scene_by_index(1)
                    -- Add the loading scene
                    scaleform.Stage.add_scene(loading)
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