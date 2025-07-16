local exec = require("./exec")

local function build(): ()
	exec("rojo", {"build", "-o", "ethical-eli-hub.rbxl"})
end

return build