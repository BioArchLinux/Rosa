#!/usr/bin/lua

local lfs = require("lfs") -- need lfs lib

local function get_pkgdir(command)
   local pkglist = io.popen(command)
   local pkgdir = {}
   for line in pkglist:lines() do
      line = line:gsub("\n", "")
      table.insert(pkgdir, line)
   end
   pkglist:close()
   return pkgdir
end

local function get_string(linestr, desc_tmp)
   local file_res = ""
   local cont = false
   for line in desc_tmp:gmatch("[^\n]+") do
      if line == linestr or cont then -- If find %FILES%
         cont = true -- start reading
         if line:match("^%s*$") or (line:sub(1,1) == "%" and line ~= linestr) then -- find empty line or (start symbol is % and not linestr)
            cont = false -- stop reading
         elseif cont and line ~= linestr then
            file_res = file_res .. line .. "\n"
         end
      end
   end
   return file_res
end

local function get_content(pkgdir)
   local name_ct, base_ct, version_ct, desc_ct, csize_ct, isize_ct, url_ct, license_ct, arch_ct, builddate_ct, packager_ct, depends_ct, optdepends_ct, makedepends_ct, files_ct = {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}

   for i = 1, #pkgdir do
      local desc_tm = io.open("data/" .. pkgdir[i] .. "/desc", "r")
      local desc_tmp = desc_tm:read("*a")
      desc_tm:close()
      -- read name --
      local desc_res = get_string("%NAME%", desc_tmp)
      table.insert(name_ct, desc_res)
      local desc_res = ""
      -- read base --
      local desc_res = get_string("%BASE%", desc_tmp)
      table.insert(base_ct, desc_res)
      local desc_res = ""
      -- read version --
      local desc_res = get_string("%VERSION%", desc_tmp)
      table.insert(version_ct, desc_res)
      local desc_res = ""
      -- read desc --
      local desc_res = get_string("%DESC%", desc_tmp)
      table.insert(desc_ct, desc_res)
      local desc_res = ""
      -- read csize --
      local desc_res = get_string("%CSIZE%", desc_tmp)
      table.insert(csize_ct, desc_res)
      local desc_res = ""
      -- read isize --
      local desc_res = get_string("%ISIZE%", desc_tmp)
      table.insert(isize_ct, desc_res)
      local desc_res = ""
      -- read url --
      local desc_res = get_string("%URL%", desc_tmp)
      table.insert(url_ct, desc_res)
      local desc_res = ""
      -- read license --
      local desc_res = get_string("%LICENSE%", desc_tmp)
      table.insert(license_ct, desc_res)
      local desc_res = ""
      -- read arch --
      local desc_res = get_string("%ARCH%", desc_tmp)
      table.insert(arch_ct, desc_res)
      local desc_res = ""
      -- read builddate --
      local desc_res = get_string("%BUILDDATE%", desc_tmp)
      table.insert(builddate_ct, desc_res)
      local desc_res = ""
      -- read packager --
      local desc_res = get_string("%PACKAGER%", desc_tmp)
      table.insert(packager_ct, desc_res)
      local desc_res = ""
      -- read depends --
      local desc_res = get_string("%DEPENDS%", desc_tmp)
      table.insert(depends_ct, desc_res)
      local desc_res = ""
      -- read optdepends --
      local desc_res = get_string("%OPTDEPENDS%", desc_tmp)
      table.insert(optdepends_ct, desc_res)
      local desc_res = ""
      -- read makedepends --
      local desc_res = get_string("%MAKEDEPENDS%", desc_tmp)
      table.insert(makedepends_ct, desc_res)
      local desc_res = ""
   end
   --read desc end--

   --read files--
   for i = 1, #pkgdir  do
      local file_tm = io.open("data/" .. pkgdir[i] .. "/files", "r")
      local file_tmp = file_tm:read("*a")
      file_tm:close()
      local file_res = get_string("%FILES%", file_tmp)
      table.insert(files_ct, file_res)
   end
   --read files end--

   return name_ct, base_ct, version_ct, desc_ct, csize_ct, isize_ct, url_ct, license_ct, arch_ct, builddate_ct, packager_ct, depends_ct, optdepends_ct, makedepends_ct, files_ct
end

local function write_api(name, func, func_str)
   local nname = name:gsub("%s+", "")
   lfs.mkdir("/usr/share/lilac/api/" .. nname)
   local fn = string.format("/usr/share/lilac/api/%s/%s", nname, func_str)
   local apifile = assert(io.open(fn, "w+"), "Error: cannot open file " .. fn)
   apifile:write(func or "")
   apifile:close()
end

local function gen_api(params)
   os.execute("mkdir -p /usr/share/lilac/api")
   local param_names = {"name", "base", "version", "desc", "csize", "isize", "url", "license", "arch", "builddate", "packager", "depends", "optdepends", "makedepends", "files"}
   for i = 1, #params.name do -- #params.name: length of params.name
      for _, param_name in ipairs(param_names) do
         local ok, err = pcall(write_api, params.name[i], params[param_name][i], param_name)
         if not ok then
            print("Error: failed to write api for " .. params.name[i] .. "/" .. param_name .. ": " .. err)
         end
      end
   end
end

--main function--
time = os.date("*t")
print(("%02d:%02d:%02d"):format(time.hour, time.min, time.sec))
local mk_dir = os.execute("rm -rf /usr/share/lilac/Rosa/data && mkdir -p /usr/share/lilac/Rosa/data")
if mk_dir then
   os.execute("tar xf /usr/share/lilac/Repo/x86_64/bioarchlinux.files -C /usr/share/lilac/Rosa/data/")
end
local pkgdir = get_pkgdir("cd /usr/share/lilac/Rosa/data/ && ls -D")
local name_ct, base_ct, version_ct, desc_ct, csize_ct, isize_ct, url_ct, license_ct, arch_ct, builddate_ct, packager_ct, depends_ct, optdepends_ct, makedepends_ct, files_ct  = get_content(pkgdir)
print("Sucess: read finished")
time = os.date("*t")
print(("%02d:%02d:%02d"):format(time.hour, time.min, time.sec))
os.execute("rm -rf /usr/share/lilac/api/*")
local params = {
   name = name_ct,
   base = base_ct,
   version = version_ct,
   desc = desc_ct,
   csize = csize_ct,
   isize = isize_ct,
   url = url_ct,
   license = license_ct,
   arch = arch_ct,
   builddate = builddate_ct,
   packager = packager_ct,
   depends = depends_ct,
   optdepends = optdepends_ct,
   makedepends = makedepends_ct,
   files = files_ct
}
gen_api(params)
print("Sucess: write finished")
time = os.date("*t")
print(("%02d:%02d:%02d"):format(time.hour, time.min, time.sec))
