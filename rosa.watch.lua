#!/usr/bin/lua

local lfs = require("lfs")

local rosalua = "/usr/share/lilac/Rosa/rosa.lua"
local filepath = "/usr/share/lilac/Repo/x86_64/bioarchlinux.files" -- what I watch
local last_modified = nil
local attr = lfs.attributes(filepath)
last_modified = attr.modification

--watch file--
local function check_changes()
  -- current time
  local attr = lfs.attributes(filepath)
  local current_modified = attr.modification
  -- if different
  if current_modified ~= last_modified then
    -- update info
    last_modified = current_modified
    -- run script
    print("Executing Rosa Lua")
    os.execute("lua " .. rosalua)
  end
end

--45s sync--
while true do
  check_changes()
  os.execute("sleep " .. tonumber(45)) -- 45s
end
