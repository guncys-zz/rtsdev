-----------------------------------------------------------------------------------
-- This implementation uses the default SimpleProject and the Project extensions are
-- used to extend the SimpleProject behavior.

-- This is the global table name used by Appkit Basic project to extend behavior
Project = Project or {}

require 'script/lua/flow_callbacks'
require 'script/lua/tools'
require 'script/lua/ui' --UI用のスクリプトのインポート
require 'script/lua/environment'

--プロジェクトで使用するlevelにアクセスするための名前定義
Project.level_names = {
    mainmenu = "content/levels/mainmenu",
	testmap = "content/levels/testmap1",  
	testmap1 = "content/levels/users/uehara/physx_test",
	tani_sandbox = "content/levels/users/taniguchi/tani_sandbox",
	stage1 = "content/levels/stage1",
	stage2 = "content/levels/stage2",
	stage3 = "content/levels/stage3",
	stage4 = "content/levels/stage4",
	test_cinematics = "content/levels/test_cinematics",
	ending = "content/levels/ending"
}

-- Can provide a config for the basic project, or it will use a default if not.
-- ベーシックプロジェクトのコンフィグ設定を提供
local SimpleProject = require 'core/appkit/lua/simple_project'
SimpleProject.config = {
	--standalone_init_level_name = Project.level_names.testmap,
	standalone_init_level_name = Project.level_names.mainmenu,
	camera_unit = "core/appkit/units/camera/camera",
	camera_index = 1,
	shading_environment = nil, -- Will override levels that have env set in editor.
	create_free_cam_player = true, -- Project will provide its own player.
	exit_standalone_with_esc_key = true
}

-- Optional function by SimpleProject after level, world and player is loaded
-- but before lua trigger level loaded node is activated.
--この関数はlevelとworldとplayerがロードされた後にSimpleProjectに呼ばれる。（lua trigger level nodeがアクティブになる前）
function Project.on_level_load_pre_flow()
    --現在のlevel名を取得
    local level_name = SimpleProject.level_name
    if level_name == nil then
       --level名がnilならなんかのエラー
    elseif level_name == Project.level_names.mainmenu then
       --mainmenuならmainmenuスクリプトを読み込んで、Start関数を呼ぶ
		local MainMenu = require 'script/lua/mainmenu'
		MainMenu.start()
    elseif level_name == Project.level_names.testmap or 
        level_name == Project.level_names.stage1 or
        level_name == Project.level_names.stage2 or 
        level_name == Project.level_names.stage3 or
        level_name == Project.level_names.stage4 or
        level_name == Project.level_names.tani_sandbox then
       --testmapならgameuiスクリプトを読み込んで、Start関数を呼ぶ
        local GameUI = require 'script/lua/gameui'
        GameUI.start()
        local UIanim = require 'script/lua/ui'
        if level_name == Project.level_names.stage1 then
            UIanim.reset(9,1)
        elseif level_name == Project.level_names.stage2 then
            UIanim.reset(9,250)
        elseif level_name == Project.level_names.stage3 then
            UIanim.reset(9,500)
        elseif level_name == Project.level_names.stage4 then
            UIanim.reset(9,750)
        end
    elseif level_name == Project.level_names.test_cinematics then
        local Opening = require 'script/lua/opening'
        Opening.start()
    elseif level_name == Project.level_names.ending then
        local Ending = require 'script/lua/ending'
        Ending.start()
    end

end

-- Optional function by SimpleProject after loading of level, world and player and
-- triggering of the level loaded flow node.
--この関数はlevelとworldとplayerがロードされた後にSimpleProjectに呼ばれる。（level loaded flow nodeのトリガーとなる）
function Project.on_level_shutdown_post_flow()
end

-- Optional function called by SimpleProject after world update (we will probably want to split to pre/post appkit calls)
-- この関数はworldの更新後にSimpleProjectから呼ばれる
function Project.update(dt)
    if stingray.Window then
        stingray.Window.set_show_cursor(true)
        stingray.Window.set_clip_cursor(false)
    end
end

-- Optional function called by SimpleProject *before* appkit/world render
function Project.render()
end

-- Optional function called by SimpleProject *before* appkit/level/player/world shutdown
function Project.shutdown()
end

return Project
