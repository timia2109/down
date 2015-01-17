--[[
	Down [_] the jQuery for CC
	Feel free to help and add:
		github.com/timia2109/down
		
	Helpers:
		timia2109
		
]]

_ = {}
down = _

_.build = 1


--Extra string methods
function string.say(self, ... )
	print(self, ... )
end

function string.exec(self,pFenv)
	local fenv
	if pFenv then fenv = pFenv
	else fenv = _G end
	return a,b = pcall(setfenv(loadstring(self),fenv))
end	

function string.split(self, pattern)

end

function _.import(pImp)
	if _.isTable(pImp) then
		for i,v in pairs(pImp) do
			if _[i] == nil then
				_[i] = v
			else
				error("Can't override "..i)
			end
		end
	else
		--load file and import
	end
end

function _.wget(pURL, tPost, tHeader) 
	local req
	if tPost then
		local post = ""
		for i,v in pairs(tPost) do
			post = post..i.."="..v.."&"
		end
		req = http.post(pURL,post, tHeader)
	else
		req = http.get(pURL)
	end
	if req then
		return req.readAll()
	else
		error("Can't load '"..pURL.." maybe whitelist?",0)
	end
end

function _.dloadFile(pURL, pSave)
	local req = _.wget(pURL)
	_.putFile(pSave,req)
end

function _.execUrl(pUrl,pFenv)
	local fenv = pFenv ~= nil and pFenv or _G
	local s = _.wget(pUrl)
	return s:exec(fenv)
end

function _.meta(pTable, pMeta)
	if pMeta then
		setmetatable(pTable, pMeta)
	else
		return getmetatable(pTable)
	end
end

function _.putFile(pFile, pContent)
	local f = fs.open(pFile, "w")
	f.write(pContent)
	f.close()
end

function _.getFile(pFile)
	if fs.exists(pFile) then
		local f = fs.open(pFile,"r")
		local r = fs.readAll()
		f.close()
		return r
	else
		return false
	end
end

function _.addToFile(pFile,pAdd,pNewLine)
	if pNewLine then
		pAdd = "\n"..pAdd
	end
	local pre = _.getFile(pFile)
	if pre == false then
		return false
	end
	_.putFile(pFile,pre..pAdd)
	return true
end

function _.cloneTable(pTable, inTable, pJustIf)
	local r = inTable or {} 
	local justIf
	if pJustIf then
		justIf = pJustIf
	else
		justIf = function() return true end
	end
	
	for i,v in pairs(pTable)
		if justIf(i,v) then
			if _.isTable(v) then
				r[i] = _.cloneTable(v)
			else
				r[i] = v
			end
		end
	end
	return r
end

function _.api(pName,pUrl)
	local lPath
	if fs.exists(pName) then
		lPath = pName
	elseif fs.exists("apis",pName) then
		lPath = "apis/"..pName
	else
		_.dloadFile(pUrl,"apis/"..pName)
		lPath = "apis/"..pName
	end
	os.loadAPI(lPath)
end

function _.checkVersion(v1, v2)
	if v1 == v2 then
		return 0
	else
		local h1,h2 = v1:split("."), v2:split(".")
		local l
		if #h1 > #h2 then
			l = #h1
		else
			l = #h2
		end
		for i=1, l do
			if h1[i] > h2[i] then
				return 1
			elseif h1[i] < h2[i] then
				return 2
			end
		end
	end
end

local dT = {"Number","String","Boolean","Table","Function","Nil"}
for i,v in pairs(dT)
	_["is"..v] = function(g) return type(g) == v:lower() end
end

function _.isEmpty(g)
	if _.isTable(g) then
		return #g == 0
	elseif _.isString(g) then
		return g == ""
	end
	return g == nil
end

function _.isset(pVal, pDo)
	if pVal ~= nil then
		pDo()
	end
end

function _.config(pName, pIfNotExists)
	local t,mt = {},{}
	mt.__index = mt
	_.meta(t,mt)
		
	function mt:save()
		local cT = _.cloneTable(self,{},function (i,v)
			return i:sub(1,2) ~= "__"
		end)
		_.putFile(self.__path,_.serialize(cT))
	end
	
	function mt:load()
		local lTable = _.unserialize(_.getFile(self.__path))
		_.cloneTable(lTable,self)
	end
	
	m.__path = ".config/"..pName
	if fs.exists(m.__path) then
		m:load()
	else
		if pIfNotExists then
			_.cloneTable(pIfNotExists,self)
		end
	end
	
	return t
end
