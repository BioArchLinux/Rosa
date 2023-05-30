#!/usr/bin/lua

local lfs = require("lfs")

local last_modified = nil

--watch file--
local function check_changes()
  -- current time
  local current_modified = os.date("%c", lfs.attributes("/usr/share/lilac/Repo/x86_64/bioarchlinux.files").modification)
  -- if different
  if current_modified ~= last_modified then
    -- run script
    print("Executing Rosa Lua")
    os.execute("/usr/bin/lua /usr/share/lilac/Rosa/rosa.lua")
    -- update info
    last_modified = current_modified
  end
end

--45s sync--
while true do
  check_changes()
  os.execute("sleep " .. tonumber(45)) -- 45s
end
