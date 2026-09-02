local PLUGIN = PLUGIN

PLUGIN.name = "PlaySound Package"
PLUGIN.author = "salt"
PLUGIN.description = "Adds commands to play global/local sounds from a file, a global URL stream, and an entity mounted local sound. Also adds a global stopsound."
PLUGIN.license = [[
Copyright 2021 Captain Salt
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

if(SERVER)then
  	util.AddNetworkString("SoundGlobal")
  	util.AddNetworkString("SoundURL")

	function PLUGIN:GlobalSound(path,level,sndpitch,snddsp)
    	net.Start("SoundGlobal")
        	net.WriteString(path)
        	net.WriteFloat(level)
        	net.WriteInt(sndpitch,32)
        	net.WriteInt(snddsp,32)
    	net.Broadcast()
	end

	function PLUGIN:GlobalURL(path,volume,pitch)
		net.Start("SoundURL")
		net.WriteString(path)
		net.WriteFloat(volume)
		net.WriteFloat(pitch)
		net.Broadcast()
  	end
end

if(CLIENT)then
	net.Receive("SoundURL", function()
		local sndString = net.ReadString()
		local sndVolume = net.ReadFloat()
		local sndPitch = net.ReadFloat()
        
        print(". \n"..sndString)
        print(". \n"..sndVolume)
        print(". \n"..sndPitch)
        
		sound.PlayURL( sndString, "Mono", function(snd)
		snd:SetVolume( sndVolume )
		snd:SetPlaybackRate( sndPitch )
		snd:Play()
		end) --I'm not sure if i need 'mono' in the flag arg
	end)
  
  	net.Receive("SoundGlobal", function()
		--surface.PlaySound(net.ReadString())
		local snd = net.ReadString()
		local sndlevel = net.ReadFloat()
		local sndpitch = net.ReadInt(32)
		local snddsp = net.ReadInt(32)
		LocalPlayer():EmitSound(snd,75,sndpitch,sndlevel,CHAN_AUTO,0,snddsp)
	end)
end

ix.command.Add("playSoundLocal", {
	description = "Plays a sound in an specified area",
	adminOnly = true,
	arguments = {ix.type.string, bit.bor(ix.type.number, ix.type.optional), bit.bor(ix.type.number, ix.type.optional), bit.bor(ix.type.number, ix.type.optional)},
	OnRun = function (self, client, soundstring, range, pitch, dsp)
		level = math.Clamp(range or 75, 45, 165)
		sndpitch = math.Clamp(pitch or 100, 15, 255)
		snddsp = math.max(dsp or 0, 0)
		sound.Play(soundstring,client:GetPos(), level, pitch, 1, dsp)
	end
})

ix.command.Add("attachSound", {
	description = "Plays a sound that follows the specified entity or yourself.",
	adminOnly = true,
	arguments = {ix.type.string, bit.bor(ix.type.number,ix.type.optional), bit.bor(ix.type.number, ix.type.optional), bit.bor(ix.type.number, ix.type.optional)},
	OnRun = function (self, client, soundstring, range, pitch, dsp)
		local data = {}
		data.start = client:GetShootPos()
		data.endpos = data.start + client:GetAimVector() * 96
		data.filter = client
		local trace = util.TraceLine(data)
		local target = trace.Entity
		level = math.Clamp(range or 75, 45, 165)
		sndpitch = math.Clamp(pitch or 100, 15, 255)
		snddsp = math.max(dsp or 0, 0)
		if(IsValid(target)) then
		target:EmitSound(soundstring,level,sndpitch,1,CHAN_AUTO,0,snddsp)
		else
		client:EmitSound(soundstring,level,sndpitch,1,CHAN_AUTO,0,snddsp)
		end
	end
})


ix.command.Add("playSoundGlobal",{
	description = "Plays a sound globally.",
	arguments = {ix.type.string, bit.bor(ix.type.number,ix.type.optional), bit.bor(ix.type.number, ix.type.optional), bit.bor(ix.type.number, ix.type.optional)},
	adminOnly = true,
	OnRun = function (self, client, path, volume, pitch, dsp)
		level = math.Clamp(volume or 1, 0.1, 1)
		sndpitch = math.Round(math.Clamp(pitch or 100, 15, 255))
		snddsp = math.Round(math.max(dsp or 0, 0))
		PLUGIN:GlobalSound(path,level,sndpitch,snddsp)
		for _, v in ipairs(player.GetAll()) do
			if (v:IsAdmin()) then
				v:Notify(client:Name().." has started a global sound.")
			end
		end
	end
})

ix.command.Add("playURL",{
	description = "Plays a global sound from a streamable URL.",
	arguments = {
		ix.type.string, 
		bit.bor(ix.type.number, ix.type.optional),
		bit.bor(ix.type.number, ix.type.optional)
	},
	adminOnly = true,
	OnRun = function(self, client, path, volume, pitch)
		if !volume then volume = 1 end
		if !pitch then pitch = 1 end
        if !(CLIENT) then
          PLUGIN:GlobalURL(path, volume, pitch)
          for _, v in ipairs(player.GetAll()) do
            if (v:IsAdmin()) then
                v:Notify(client:Name().." has started a global sound from a URL.")
            end
          end 
        end
	end
})

ix.command.Add("stopsounds",{
	description = "Stops all sounds",
	adminOnly = true,
	OnRun = function (self, client)
		for k, v in pairs (player.GetAll()) do
			v:ConCommand("stopsound")
			v:Notify("Sounds have been stopped.")
		end
	end
})
