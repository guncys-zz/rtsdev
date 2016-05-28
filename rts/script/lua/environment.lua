require 'core/appkit/lua/class'
require 'core/appkit/lua/app'

Environment = Environment or{}

radius_val = 1.0

function Environment.set_start_vignette(arg)
    radius_val = arg.Radius
end

function Environment.change_vignett(arg)
    
    radius_val = radius_val + arg.Change
    
    if ( radius_val < arg.Min ) then
        return
    end

    if ( radius_val > arg.Max ) then
        return
    end

    local data_component_manager = stingray.EntityManager.data_component(SimpleProject.world)
    local all_entity_handles = stingray.World.entities(SimpleProject.world)

    -- iterate through all entities in the world.
    for _, entity_handle in ipairs(all_entity_handles) do

        -- the shading environment is a data component, so we retrieve all data components
        -- owned by this entity and iterate through them.
        -- instances() returns the values on the stack, so we wrap the call in {} to get an array.
        local all_data_component_handles = {stingray.DataComponent.instances(data_component_manager, entity_handle)}
        for _, data_component_handle in ipairs(all_data_component_handles) do

            -- Test whether or not this data component is the shading environment component
            -- that we want to modify.
            -- Missing properties return nil, so this is "safe".
            local shading_environment_mapping_resource_name = stingray.DataComponent.get_property(data_component_manager, entity_handle, data_component_handle, {"shading_environment_mapping"})
            if shading_environment_mapping_resource_name == "core/stingray_renderer/shading_environment_components/vignette" then
                if (shading_env_entity == nil) then
                    -- remember the shading environment entity.
                    shading_env_entity = entity_handle
                end
                vignette_component = data_component_handle;
                -- now we have the shading environment entity and the component, we can set the
                -- value we want for the property.
                stingray.DataComponent.set_property(data_component_manager, shading_env_entity, vignette_component, {"vignette_radius"}, radius_val)
            end
        end
    end

    print(time)
end

function Environment.close_vignett(arg)
    
    radius_val = radius_val - 0.1
    
    if ( radius_val < 0 ) then
        return
    end

    local data_component_manager = stingray.EntityManager.data_component(SimpleProject.world)
    local all_entity_handles = stingray.World.entities(SimpleProject.world)

    -- iterate through all entities in the world.
    for _, entity_handle in ipairs(all_entity_handles) do

        -- the shading environment is a data component, so we retrieve all data components
        -- owned by this entity and iterate through them.
        -- instances() returns the values on the stack, so we wrap the call in {} to get an array.
        local all_data_component_handles = {stingray.DataComponent.instances(data_component_manager, entity_handle)}
        for _, data_component_handle in ipairs(all_data_component_handles) do

            -- Test whether or not this data component is the shading environment component
            -- that we want to modify.
            -- Missing properties return nil, so this is "safe".
            local shading_environment_mapping_resource_name = stingray.DataComponent.get_property(data_component_manager, entity_handle, data_component_handle, {"shading_environment_mapping"})
            if shading_environment_mapping_resource_name == "core/stingray_renderer/shading_environment_components/vignette" then
                if (shading_env_entity == nil) then
                    -- remember the shading environment entity.
                    shading_env_entity = entity_handle
                end
                vignette_component = data_component_handle;
                -- now we have the shading environment entity and the component, we can set the
                -- value we want for the property.
                stingray.DataComponent.set_property(data_component_manager, shading_env_entity, vignette_component, {"vignette_radius"}, radius_val)
            end
        end
    end

    print(time)
end


function Environment.set_vignett_rad(arg)

    local data_component_manager = stingray.EntityManager.data_component(SimpleProject.world)
    local all_entity_handles = stingray.World.entities(SimpleProject.world)

    -- iterate through all entities in the world.
    for _, entity_handle in ipairs(all_entity_handles) do

        -- the shading environment is a data component, so we retrieve all data components
        -- owned by this entity and iterate through them.
        -- instances() returns the values on the stack, so we wrap the call in {} to get an array.
        local all_data_component_handles = {stingray.DataComponent.instances(data_component_manager, entity_handle)}
        for _, data_component_handle in ipairs(all_data_component_handles) do

            -- Test whether or not this data component is the shading environment component
            -- that we want to modify.
            -- Missing properties return nil, so this is "safe".
            local shading_environment_mapping_resource_name = stingray.DataComponent.get_property(data_component_manager, entity_handle, data_component_handle, {"shading_environment_mapping"})
            if shading_environment_mapping_resource_name == "core/stingray_renderer/shading_environment_components/vignette" then
                if (shading_env_entity == nil) then
                    -- remember the shading environment entity.
                    shading_env_entity = entity_handle
                end
                vignette_component = data_component_handle;
                -- now we have the shading environment entity and the component, we can set the
                -- value we want for the property.
                radius_val = arg.Radius
                stingray.DataComponent.set_property(data_component_manager, shading_env_entity, vignette_component, {"vignette_radius"}, radius_val)
            end
        end
    end

    print(time)
end


-- return Environment
