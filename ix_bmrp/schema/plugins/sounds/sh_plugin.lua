local PLUGIN = PLUGIN

PLUGIN.name = "FancySound"
PLUGIN.author = "Rowan From Roswell"
PLUGIN.description = "Flexible global sound system."

PLUGIN.soundFolder = "fancysounds/"
PLUGIN.sounds = {}
PLUGIN.currentSound = nil


if SERVER then

    function PLUGIN:InitializedPlugins()

        local files = file.Find("sound/" .. self.soundFolder .. "*", "GAME")

        for _, v in ipairs(files) do
            local fullPath = self.soundFolder .. v
            local shortName = string.StripExtension(v)

            self.sounds[shortName] = fullPath

            resource.AddFile("sound/" .. fullPath)

            print("[FancySound] Registered sound: " .. shortName .. " -> " .. fullPath)
        end

    end

end


ix.command.Add("FancySound", {
    description = "Play a global sound from the fancysounds folder.",
    arguments = {
        ix.type.string,
        ix.type.number,
        ix.type.number
    },
    adminOnly = true,

    OnRun = function(self, client, soundName, volume, pitch)

        local soundPath = PLUGIN.sounds[soundName]

        if not soundPath then
            print("[FancySound] INVALID SOUND: " .. tostring(soundName))
            client:Notify("Invalid sound name.")
            return
        end

        volume = math.Clamp(volume or 100, 0, 150)
        pitch = math.Clamp(pitch or 100, 50, 255)

        PLUGIN.currentSound = soundPath

        for _, ply in ipairs(player.GetAll()) do
            ply:EmitSound(soundPath, 75, pitch, volume / 100)
        end

        print("[FancySound] Playing sound: " .. soundName)
    end
})


ix.command.Add("StopFancySound", {
    description = "Stop the currently playing global sound.",
    adminOnly = true,

    OnRun = function(self, client)

        if not PLUGIN.currentSound then
            client:Notify("No sound is currently playing.")
            return
        end

        for _, ply in ipairs(player.GetAll()) do
            ply:StopSound(PLUGIN.currentSound)
        end

        print("[FancySound] Stopped sound: " .. PLUGIN.currentSound)

        PLUGIN.currentSound = nil
    end
})


ix.command.Add("ListFancySounds", {
    description = "List all available fancy sounds.",
    adminOnly = true,

    OnRun = function(self, client)

        client:Notify("Available sounds:")

        for name, _ in pairs(PLUGIN.sounds) do
            client:Notify("- " .. name)
        end

    end
})