local SoundService = game:GetService("SoundService")

local MusicPlaylist = SoundService.Music:GetChildren()

table.sort(MusicPlaylist, function(a, b)
	return a.Name < b.Name
end)

local counter = 1
while true do
	if counter > #MusicPlaylist then
		counter = 1
	end
	local Music:Sound = MusicPlaylist[counter]
	print(`Current played Music: {Music.Name}`)
	Music:Play()
	Music.Ended:Wait()
	counter += 1
end
