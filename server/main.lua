local maintenancemode = false

RegisterCommand("maintenancemode", function(source, args)
    if source == 0 then
        if args[1] == "true" or args[1] == "false" then
            maintenancemode = args[1]
            print("Set maintenance mode to: " .. args[1])
        else
            print("Invalid arguemnts. Please use /maintenancemode [toggle]")
        end
    else
        if IsPlayerAceAllowed(source, Config.Permission) then
            if args[1] == "true" or args[1] == "false" then
                maintenancemode = args[1]
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Set maintenance mode to: ' .. args[1], length = 2500, style = { ['color'] = '#ffffff' } })
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Invalid arguments. Please use /maintenancemode [toggle]', length = 2500, style = { ['color'] = '#ffffff' } })
            end
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'ERROR: No Permission.', length = 2500, style = { ['color'] = '#ffffff' } })
        end
    end
end)

CreateThread(function()
    TriggerClientEvent('chat:addSuggestion', -1, '/maintenancemode', 'Toggles the server maintenance mode', {
        { name="Toggle", help="true or false" }
    })
end)

AddEventHandler("playerConnecting", function(_, _, deferrals)
    local src = source
    deferals.defer()
    Wait(0)
    
    if maintenancemode == "true" then
        deferrals.done(Config.MaintenanceModeMsg)
        print("[" .. src .. "] Connection rejected - Server maintenance mode is enabled")
    else
        deferrals.done()
    end
end)
