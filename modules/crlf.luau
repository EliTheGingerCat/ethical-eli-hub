local fs = require("@lune/fs")

local function convert_newlines(s: string): string
	local result = string.gsub(
		s,
		"([^\r])\n",
		"%1\r\n"
	)
	return result
end

local text_extensions = {"luau", "json"}
for index, extension in text_extensions do
	text_extensions[index] = "." .. extension .. "$"
end
local function is_text(path: string): boolean
	for _, extension in text_extensions do
		if string.match(path, extension) ~= nil then
			return true
		end
	end
	return false
end

-- Recursive.
local function crlf(start_path: string): ()
	local paths = {start_path}
	local paths_size = #paths

	for _, path in paths do
		if fs.isDir(path) then
			local children = fs.readDir(path)
			for index, child in children do
				paths[paths_size + index] = path .. "/" .. child
			end
			paths_size += #children
		elseif fs.isFile(path) and is_text(path) then
			local source = fs.readFile(path)
			local fixed = convert_newlines(source)
			fs.writeFile(path, fixed)
		end
	end
end

return crlf