local maintenancemode = false

RegisterCommand(Config.Command, function(source, args)
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
                TriggerClientEvent("mythic_notify:client:SendAlert", source, { type = "inform", text = "Set maintenance mode to: " .. args[1], length = 2500, style = { ["color"] = "#ffffff" } })
            else
                TriggerClientEvent("mythic_notify:client:SendAlert", source, { type = "error", text = "Invalid arguments. Please use /maintenancemode [toggle]", length = 2500, style = { ["color"] = "#ffffff" } })
            end
        else
            TriggerClientEvent("mythic_notify:client:SendAlert", source, { type = "error", text = "ERROR: No Permission.", length = 2500, style = { ["color"] = "#ffffff" } })
        end
    end
end)

CreateThread(function()
    Wait(100)
	PerformHttpRequest("https://raw.githubusercontent.com/Plactrix/versions/main/maintenancemode.json", function(code, res, headers)
		if code == 200 then
			local data = json.decode(res)
            if data["version"] ~= GetResourceMetadata(GetCurrentResourceName(), "version") then
				print("^1Notice^7: There is an update available for ^3plux-maintenancemode^7. Please head to our github page to update it - https://github.com/Plactrix/plux-maintenance")
			end
		end
	end, "GET")
end)

AddEventHandler("playerConnecting", function(_, _, deferrals)
    local src = source
    deferrals.defer()
    Wait(0)
    
    if maintenancemode == "true" and not IsPlayerAceAllowed(src, Config.BypassPermission) then
        deferrals.done(Config.MaintenanceModeMsg)
        print("[" .. src .. "] Connection rejected - Server maintenance mode is enabled")
    else
        deferrals.done()
    end
end)
