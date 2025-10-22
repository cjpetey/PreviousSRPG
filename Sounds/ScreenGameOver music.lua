local audio_file = "fold.ogg"

local style = ThemePrefs.Get("VisualStyle")
if string.match(style, "SRPG") then
	audio_file = style.."-GameOver.ogg"
end

return THEME:GetPathS("", audio_file)
