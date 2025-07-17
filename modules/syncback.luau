local exec = require("./exec")

local function syncback(old: boolean?): ()
	local syncback_file: string
	if old then
		syncback_file = "syncback-archive.project.json"
	else
		syncback_file = "syncback.project.json"
	end

	exec("rojo-syncback", {"syncback", syncback_file, "--input", "./ethical-eli-hub.rbxl"}, {
		stdio = {
			stdin = "y"
		}
	})
end

return syncback