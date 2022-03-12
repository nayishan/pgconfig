local function readCmd(cmd)
	local ret = io.popen(cmd)
	local out = ret:read("*a")
	local _,_,str1 = out:find("([^\n]+)")
	ret:close()
	return str1
end

local base = os.getenv("HOME")
local pgCode = base .. "/gitCode/postgresql-12.2"
local kbCode = base .. "/gitCode/postgresql_master"
local rc = base .. "/.bashrc"
local rctmp = base .. "/rctmp"
local rcbak = base .. "/bashrcbak"
local pgHome = base .. "/pgrelease"
local kbHome = base .. "/kbrelease"
local pgUser = readCmd("whoami")
local kbUser = readCmd("whoami")
local pgLog = base .. "/pglog/pg"
local kbLog = base .. "/kblog/kb"
local userBin = base .. "/pgconfig"
local pgData = pgHome .. "/data"
local kbData = kbHome .. "/data"
local kbManPath = kbHome .. "/share/man"
local pgManPath = pgHome .. "/share/man"
local Lang = "en_US.utf8"
local Date = [[`date +"%Y-%m-%d%H:%M:%S"`]]
local kbPort = "34533"
local pgPort = "34532"
local kbHost = "localhost"
local pgHost = "localhost"

local pgKeyword = {
	KBHOME = {"KBHOME",kbHome},
	PGHOME = {"PGHOME",pgHome},
	KBCODE = {"KBCODE",kbCode},
	PGCODE = {"PGCODE",pgCode},
	KBUSER = {"KBUSER",kbUser},
	PGUSER = {"PGUSER",pgUser},
	KBDATA = {"KBDATA",kbData},
	PGDATA = {"PGDATA",pgData},
	KBMANPATH = {"KBMANPATH",kbManPath},
	PGMANPATH = {"PGMANPATH",pgManPath},
	LANG = {"LANG",Lang},
	DATE = {"DATE",Date},
	KBPORT = {"KBPORT",kbPort},
	PGPORT = {"PGPORT",pgPort},
	KBHOST = {"KBHOST",kbHost},
	PGHOST = {"PGHOST",pgHost},
	KBLOG = {"KBLOG",kbLog},
	PGLOG = {"PGLOG",pgLog},
}
--print(#pgKeyword)
local function UserBin(fd,line)
	local count = line:find("PATH%s*=")
	if(count ~= nil) then
		local str = line:gsub(":" .. userBin,"")
		fd:write(str .. ":" .. userBin .. "\n")
		return true
	else
		return false
	end
end

local function Rebuild()
	local old,err1 = io.open(rc,"r")
	if(not old) then
		print(err1)
		return nil
	end
	local new,err = io.open(rctmp,"w+")
	if(not new) then
		print(err)
		return nil
	end
	local keyWord = pgKeyword
	for line in old:lines() do
		local flag = false
		for key,value in pairs(keyWord) do
	    	local pos = line:find(value[1] .. "%s*=")
		    if(pos ~= nil) then
				flag = true
				new:write("export " .. value[1] .. "=" .. value[2] .. "\n")
				keyWord[key] = nil
				break
			end
		end
		if(flag == false) then
			if(false == UserBin(new,line)) then
				new:write(line .. "\n")
			end
		end
	end
	old:close()
	new:close()
end

local function BackUp()
	local ret = os.execute("cp -r " .. rc .." " ..  rcbak)
	return ret
end

local function Replace()
	local ret = os.execute("mv " .. rctmp .. " " .. rc)
	return ret
end

local function initbashrc()
	local ret = 0
	if(false == BackUp()) then
		print("Back up failed")
		ret = 1
		goto exit
	end
	if(false == Rebuild()) then
		print("Rebuild failed")
		ret = 1
		goto exit
	end
	if(false == Replace())then
		print("Replace failed")
		ret = 1
		goto exit
	end
::exit::
    return ret
end

	

initbashrc()


