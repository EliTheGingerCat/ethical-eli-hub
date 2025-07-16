local exec = require("./exec")

local function syncback(): ()
	exec("rojo-syncback", {"syncback", "syncback.project.json", "--input", "./ethical-eli-hub.rbxl"}, {
		stdio = {
			stdin = "y"
		}
	})
end

return syncback