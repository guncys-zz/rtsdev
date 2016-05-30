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

Project.GameUI = Project.GameUI or {}
local GameUI = Project.GameUI
GameUI.custom_listener = GameUI.custom_listener or nil

local start_time = 0
local damage_bool = false
--GameUIの呼び出し
function GameUI.start()
	if stingray.Window then
		stingray.Window.set_show_cursor(true)
	end

	if scaleform then
	    scaleform.Stingray.load_project_and_scene("s2d_projects/ui.s2d/ui")
		--scaleform.Stingray.load_project("test_mainmenu.s2dproj", "s2d_projects/test_mainmenu")
		scaleform.Stage.set_view_scale_mode(1)

		local custom_listener = GameUI.custom_listener
		custom_listener = scaleform.EventListener.create(custom_listener, GameUI.on_custom_event)--Creates an event listener. 
		
		GameUI.custom_listener = custom_listener
		scaleform.EventListener.connect(custom_listener, scaleform.EventTypes.Custom)--Connects the event listener to stage events of the input type. 
		local loading = scaleform.Actor.load("GameUI.s2dscene")	--GameUI用のシーンをロード
	    -- Remove the main menu scene
        scaleform.Stage.remove_scene_by_index(1)
        -- Add the loading scene
        scaleform.Stage.add_scene(loading)
	end

	local level = SimpleProject.level
--	start_time = stingray.World.time(SimpleProject.world)
	-- make sure camera is at correct location
--	local camera_unit = SimpleProject.camera_unit
---	local camera = stingray.Unit.camera(camera_unit, 1)
--	stingray.Unit.set_local_pose(camera_unit, 1, stingray.Matrix4x4.identity())
--	stingray.Camera.set_local_pose(camera, camera_unit, stingray.Matrix4x4.identity())
	Appkit.manage_level_object(level, GameUI, nil)
end
--GameUIのリリース
function GameUI.shutdown(object)
	if scaleform then
		scaleform.EventListener.disconnect(GameUI.custom_listener)
		scaleform.Stingray.unload_project()
	end

	GameUI.evt_listener_handle = nil
	Appkit.unmanage_level_object(SimpleProject.level, GameUI, nil)
	if stingray.Window then
		stingray.Window.set_show_cursor(false)
	end
end

GameUI.action = nil
function GameUI.on_custom_event(evt)
	if evt.name == "pause" then
		units = stingray.World.units_by_resource(SimpleProject.world, "content/models/characters/PPK/PPK_m")

		ppk = units[1]

	    if ppk ~= nil then
		    -- stingray.Unit.disable_animation_state_machine(ppk)
		    -- stingray.Unit.stop_simple_animation(ppk)
		    stingray.Unit.flow_event(ppk,"pause")
			end
		--ゲームをポーズするためにactionの文字列を変更
    elseif evt.name == "restart" then
        GameUI.action = "restart"
    elseif evt.name == "go_to_top" then
        GameUI.action = "go_to_top"
    elseif evt.name == "resume" then
				units = stingray.World.units_by_resource(SimpleProject.world, "content/models/characters/PPK/PPK_m")

				ppk = units[1]

		    if ppk ~= nil then
			    -- stingray.Unit.enable_animation_state_machine(ppk)
			    stingray.Unit.flow_event(ppk,"unpause")
				end
        GameUI.action = "resume"
    elseif evt.name == "change_level" then
        GameUI.action = "change_level"
    end
end

--更新処理で呼ばれる
local function perform_action()
	-- Load empty level
	if GameUI.action == "exit" then
	    stingray.Application.quit()
    end
    
	if GameUI.action == "pause" then
		--ゲームのタイムを止める処理を記述予定
		--今はメインメニューに戻る処理とする
		--GameUI.shutdown()
		--print("ポーズ状態に入っている")
		--SimpleProject.change_level(Project.level_names.mainmenu)    --testmapに遷移
	elseif GameUI.action == "restart" then
	    SimpleProject.change_level(SimpleProject.level_name)  
    elseif GameUI.action == "go_to_top" then
        SimpleProject.change_level(Project.level_names.mainmenu)
    elseif GameUI.action == "resume" then
        --ゲームを再開するスクリプト
    end
    
    if GameUI.action == "change_level" then
        if SimpleProject.level_name == Project.level_names.stage1 then
            SimpleProject.change_level(Project.level_names.stage2)
            --print("stage1->stage2")
        elseif SimpleProject.level_name == Project.level_names.stage2 then
            SimpleProject.change_level(Project.level_names.stage3)
            --print("stage2->stage3")
        elseif SimpleProject.level_name == Project.level_names.stage3 then
            SimpleProject.change_level(Project.level_names.stage4)
            --print("stage3->stage4")
        elseif SimpleProject.level_name == Project.level_names.stage4 then
            --SimpleProject.change_level(Project.level_names.stage2)
            --endシーンを呼ぶ
        end
        --print("レベル遷移")
    end
    
	GameUI.action = nil
end

-- [[Main Menu custom functionality]]--
function GameUI.update(object, dt)
	if GameUI.action == nil  then
		local time = stingray.World.time(SimpleProject.world)
		local p = stingray.Application.platform()
		if time - start_time > 1 then
			if Appkit.Util.is_pc() then
				if stingray.Keyboard.pressed(stingray.Keyboard.button_id("c")) then
				--	GameUI.action = "start"
					--local loading = scaleform.Actor.load("Loading.s2dscene")	--Loding用のシーンをロード
				--	print("cボタンが押されたよ！！！！！")
            	    -- Remove the main menu scene
                   -- scaleform.Stage.remove_scene_by_index(1)
                    -- Add the loading scene
                   -- scaleform.Stage.add_scene(loading)
				elseif stingray.Keyboard.pressed(stingray.Keyboard.button_id("esc")) then
					GameUI.action = "exit"
				end
			end
		end
    end
	perform_action()
end


return GameUI