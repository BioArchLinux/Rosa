#!/usr/bin/lua

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
      if line == linestr or cont then -- 如果找到 %FILES%
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
      local desc_tm = io.popen("cat data/" .. pkgdir[i] .. "/desc")
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
      local file_tm = io.popen("cat data/" .. pkgdir[i] .. "/files", "r")
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
   os.execute("mkdir -p api/" .. nname)
   local fn =  "api/" .. nname .. "/" .. func_str
   local apifile = io.open(fn, "w+")
   if apifile == nil then
      print("Error: cannot open file " .. fn)
      return
   end
   if func == nil then
      apifile:write("")
   else
      apifile:write(func)
   end
   print("Success: " .. fn .. " finished")
   apifile:close()
end

local function gen_api(name_ct, base_ct, version_ct, desc_ct, csize_ct, isize_ct, url_ct, license_ct, arch_ct, builddate_ct, packager_ct, depends_ct, optdepends_ct, makedepends_ct, files_ct)
   os.execute("mkdir -p api")
   for i = 1, #name_ct do -- #name_ct: length of name_ct
      write_api(name_ct[i], name_ct[i], "name")
      write_api(name_ct[i], base_ct[i], "base")
      write_api(name_ct[i], version_ct[i], "version")
      write_api(name_ct[i], desc_ct[i], "desc")
      write_api(name_ct[i], csize_ct[i], "csize")
      write_api(name_ct[i], isize_ct[i], "isize")
      write_api(name_ct[i], url_ct[i], "url")
      write_api(name_ct[i], license_ct[i], "license")
      write_api(name_ct[i], arch_ct[i], "arch")
      write_api(name_ct[i], builddate_ct[i], "builddate")
      write_api(name_ct[i], packager_ct[i], "packager")
      write_api(name_ct[i], depends_ct[i], "depends")
      write_api(name_ct[i], optdedepends, "optdepends")
      write_api(name_ct[i], makedepends_ct[i], "makedepends")
      write_api(name_ct[i], files_ct[i], "files")
   end
end


--main function--
local mk_dir = os.execute("mkdir -p data")
if (mk_dir) then
   os.execute("tar xf bioarchlinux.files -C data/")
end
local pkgdir = get_pkgdir("cd data && ls -D")
local name_ct, base_ct, version_ct, desc_ct, csize_ct, isize_ct, url_ct, license_ct, arch_ct, builddate_ct, packager_ct, depends_ct, optdepends_ct, makedepends_ct, files_ct  = get_content(pkgdir)
gen_api(name_ct, base_ct, version_ct, desc_ct, csize_ct, isize_ct, url_ct, license_ct, arch_ct, builddate_ct, packager_ct, depends_ct, optdepends_ct, makedepends_ct, files_ct)
