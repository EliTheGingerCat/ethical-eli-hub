local fs = require("@lune/fs")

local for_descendants = require("./for_descendants")

local EXTENSION_PATH = "%.meta%.json$"
local function is_meta(path: string): boolean
  return string.find(path, EXTENSION_PATH) ~= nil
end

local FILE_SERVER = [[{
  "properties": {
    "RunContext": "Server"
  }
}]]

local FILE_CLIENT = [[{
  "properties": {
    "RunContext": "Client"
  }
}]]

local function is_run_context_only(path: string): boolean
	local content = fs.readFile(path)
	return (
		   content == FILE_SERVER
		or content == FILE_CLIENT
	)
end

local function run_context(start_path: string): ()
	for_descendants(start_path, function(path)
		if is_meta(path) and is_run_context_only(path) then
			fs.removeFile(path)
		end
	end)
end

return run_context