--[[
	Down [_] the jQuery for CC
	Feel free to help and add:
		github.com/timia2109/down
		
	Helpers:
		timia2109
		
]]

_ = {}
down = _

--Down Constants
_.build = 1
_.errors = true


--Extra string methods
function string.say(self, ... )
	print(self, ... )
end

function string.exec(self,pFenv)
	local fenv
	if pFenv then 
		fenv = pFenv 
	else 
		fenv = _G 
	end
	return pcall(setfenv(loadstring(self),fenv))
end	

function string.split(self, pattern)

end

--Down internal functions
	__ = {}


	function __.error( ... )
		if term.isColor then term.setTextColor( colors.red ) end
		print(...)
		term.setTextColor( colors.white )
	end
--Real Down Functions

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

function _.wget( ... )
	local arg = { ... }
	local useT = {}
	local req, url, tPost, tHeader
	
	if #arg > 1 then
		useT.url = arg[1]
		useT.post = arg[2]
		useT.header = arg[3]
	else
		useT = arg[1]
	end
	
	function useT.getUrl()
		if useT.get and _.isTable(useT.get) then
			local r = useT.url.."?"
			for i,v in ipairs(useT.get) do
				r = r..i.."="..v.."&"
			end
			return r
		else
			return useT.url
		end
	end
	
	if useT.url:sub(1,3) == "pb:" then
		useT.url = "http://pastebin.com/raw.php?i="..useT.url
	end
	
	if useT.post then
		local post = ""
		for i,v in pairs(use.post) do
			post = post..i.."="..v.."&"
		end
		req = http.post(useT.getUrl(), post, useT.header)
	else
		req = http.get(useT.getUrl(), useT.header)
	end
	if req then
		return req.readAll()
	else
		error("Can't load '"..useT.url.." maybe whitelist?",0)
	end
end

function _.dloadFile(pURL, pSave)
	local req = _.wget{
		["url"] = pURL
	}
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
	if _.isTable(pContent) then
		pContent = _.serialize(pContent)
	end
	local f = fs.open(pFile, "w")
	f.write(pContent)
	f.close()
end

function _.getFile(pFile)
	if fs.exists(pFile) then
		local f = fs.open(pFile,"r")
		local r = f.readAll()
		if r:sub(1,1) == "{" and r:sub(r:len(), r:len() ) == "}" then
			r = _.unserialize(r)
		end
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
	
	for i,v in pairs(pTable) do
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
		if not fs.exists("apis") then
			fs.makeDir("apis")
		end
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
for i,v in pairs(dT) do
	_["is"..v] = function( ... )
		local h = { ... }
		for i,vf in pairs(h) do
			if type(vf) ~= v:lower() then
				return false
			end
		end 
		return true
	end
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

function _.mustBe(pV, pT)
	if type(pV) ~= pT then
		__.error("Var must be a "..pV..". Gets a "..type(pV))
	end 
end

function _.equals(p1,p2)
	if type(p1) == type(p2) then
		if _.isString(p1,p2) then
			return p1:lower() == p2:lower()
		elseif _.isNumber(p1,p2) then
			return p1 == p2
		end
	else
		error("p1 and p2 are not the same type ("..type(p1)..", "..type(p2)..")")
	end
end

function _.extents(pObj, pFind)
	if _.isString(pObj) then
		for i,v in pairs(pTable) do
			if not string.find(pFind, v) then
				return false
			end
		end
		return true
	elseif _.isTable(pObj) then
		for i,v in pairs(pObj) do
			if v == pObj then
				return true,i
			end
		end
		return false
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

function _.serialize(pTable, pType)
	--if _.equals(pType, "json") then
		--json
		--tbd
	--else
		--Lua
		return textutils.serialize(pTable)
	--end
end
_.serialise = _.serialize

function _.unserialize(pTable, pType)
	if pType == "json" then

	else
		return textutils.unserialize( pTable )
	end
end
_.unserialise = _.unserialize


function _.newClass(pName, pTable, pMainClass)
	if not _G.class then
		_G.class = {}
		_G.new = {}
		local function idx(pT, pSearch)
			if class[pSearch] then
				return function( ... )
					local self = {}
					setmetatable(self, {["__index"] = class[pSearch]} )
					class[pSearch].init( self, ... )
					return self
				end
			else
				return function()
					return false
				end
			end
		end
		setmetatable(_G.new, {["__index"] = idx} )
	end
	
	class[pName] = pTable
	class[pName].__className = pName
		
	if pMainClass then
		class[pName].super = function()
			class[pName].__tree = pMainClass.__tree.."/"..class[pName].__tree
			for i,v in pairs(pMainClass) do
				if i ~= "init" and not class[pName][i] then
					class[pName] = v
				end
			end
		end
	else
		class[pName].__tree = "downObject"
	end
end

function _.newClassFromString(pStr)
	--TBD
end

function _.importClass(pFile)
	_.newClassFromString( _.getFile( pFile ) )
end

function _.isObject(pV)
	return pV.__tree:sub(1,5) == "downO" 
end

function _.isA(pWhat, pObj)
	return pObj.__class == pWhat
end

_G._Object = {}
_Object.__tree = "downObject"
