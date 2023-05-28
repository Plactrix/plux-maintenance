CreateThread(function()
    Wait(2000)
    TriggerEvent("chat:addSuggestion", "/" .. Config.Command, "Toggles the server maintenance mode", {
        { name="Toggle", help="true or false" }
    })
end)