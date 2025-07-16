local exec = require("./exec")

local function build()
	exec("rojo", {"build", "-o", "build.rbxl"})
end

return build