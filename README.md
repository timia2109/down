# down
Like jQuery for ComputerCraft. Use _ instead of $. 
##### What can _ and for what is it?
down has the same intent like jQuery. It just should be SHORT.
Let me show you how short down can be:
**Load serialized table**
```lua
-- Normal way:
local file = fs.open("filename","r")
local data = textutils.unserialize( file.readAll() )
file.close()
-- -> 3 Lines
-- Let's make it in down
local data = _.getFile("filename")
```
**Use APIs**
```lua
-- Normal way:
if fs.exists("apis/api") then
	os.loadAPI("apis/api")
else
	local request = http.get("http://apiurl")
	if request then
		local file = fs.open("apis/api","w")
		file.write( request.readAll() )
		file.close()
		request.close()
		os.loadAPI("apis/api")
	else
		error("API not found! Error on downloading API!")
	end
end
-- And now with down:
_.loadAPI("api","http://apiurl")
```
**OOP with Lua**
(as example a simple button)
```lua
-- Normal:
local function newButton( pX, pY, pLen, pLabel, pCol)
	local button = {
		x = pX,
		y = pY,
		label = pLabel,
		len = pLen,
		color = pCol
	}
	local metaButton = {}
	function metaButton.draw(self)
		paintutils.drawLine( self.x, self.y, self.x+self.len, self.y, self.color)
		term.setCursorPos(self.x, self.y)
		write(self.label)
	end
	function metaButton.isClicked(self, pX, pY)
		return pY == self.y and self.x <= pX and self.x+self.len >= pX
	end
	setmetatable(button, {__index=metaButton})
	return button
end
local button = newButton(1,1,5,"Hallo", colors.red)
button:draw()
-- With down:
local button = {}
function button.init(self, pX, pY, pLen, pLabel, pCol)
	self.x = pX
	self.y = pY
	self.len = pLen
	self.label = pLabel
	self.color = pCol 
end
function button.draw(self)
	paintutils.drawLine( self.x, self.y, self.x+self.len, self.y, self.color)
	term.setCursorPos(self.x, self.y)
	write(self.label)	
end
function button.isClicked(self, pX, pY)
	return pY == self.y and self.x <= pX and self.x+self.len >= pX
end
_.newClass("Button",button)
local button = new.Button(1,2,8,"down [_]",colors.blue) --All Objects can be created with new.OBJECTNAME( args )
button:draw()
```
You also can create Sub-Classes with down!

Is that enouth to use down?
##### Want more functions?
down is communtiy based, so fork and create a pull request. And if it work, then I will include it!
##### Can I use it in my OS?
Shure feel free to use down! But I recommend, that you not copy down, let it load from this repo so you ever have the newest version!
##### How I load down?
down MUST BE LOADED WITH shell.run("/down"), because it use _G
## Usage:
```Lua
if not _ then
	if not fs.exists("/down") then
		local req = http.get("https://raw.github.com/timia2109/down/master/down.lua")
		local f = fs.open("down","w")
		f.write(req.readAll())
		f.close()
	end
	shell.run("/down")
end
```

## Methods
|Name|return|Desc|
|---|---|---|
|_.import(table pImport)|nil|Import the methods of pImport into _(down)|
|_.wget(string pUrl|table **wget**, [table pPost], [table pHeader])|string|Start a request to pUrl and return the content|
|_.dloadFile(string pUrl, string pFile)|nil|Download the url and put it in pFile|
|_.execUrl(string pUrl, [table fenv] or [_G])|return value of code|
|_.meta(table pTable, [table pMetatable])|table|return metatable of pTable and if pMetatable set new metatable|
|_.putFile(string filename, mixed content)|nil|Save content into filename. Auto-serialize!|
|_.getFile(string filename)|(string|table)/false|Get content of filename. Auto-unserialize|
|_.addToFile(string filename, string add, [boolean newLine])|boolean|Add *add* to *filename*. If *newLine* then it add "\n" before that|
|_.cloneTable(table pTable, [table into], [function if])|table|Copy *pTable* into the *return* table or into the *into* table. If *if* then only copy if it return true|
|_.api(string apiname, string url)|nil|Load the API *apiname*, if not exists it will downloaded|
|_.checkVersion(string version1, string version2)|number|return 0 if *v1* and *v2* are equal. return *1* if *v1* is newer, return *2* if *v2* is newer `v1 = "1.3443.464.06.4"`|
|_.isset(boolean if, function do)|nil|If *if* == true then exec *do*|
|_.config(string pName)|table (configObject)|Load a config table|
|_.isEmpty(mixed pVal)|boolean|See examples to watch how it works|
|_.isTable(mixed val)|boolean|Self explain|
|_.isBoolean(mixed val)|boolean|Self explain|
|_.isString(mixed val)|boolean|Self explain|
|_.isNumber(mixed val)|boolean|Self explain|
|_.isNil(mixed val)|boolean|Self explain|
|_.isFunction(mixed val)|boolean|Self explain|
|_.isObject(table Table)|boolean|return true when it's a child of _Object|
|_.isA(string Classname, obj Object)|boolean|return true when it is a Object of the class Classname|
|_.isAttr(string Attr)|boolean|Return true when Attr is not defined by down's classmanagment|
|_.serialize(table Table, [string **format**])|string|Serialize the table into a string|
|_.unserialize(string Value, [string **format**]["lua"])|table|Create a table from the string|
|_.sortField(table Table, string Field)|table|Sort the table with Selection Sort. table[i].field must be a number|

|_.newClass(string Name, table class, [table Mainclass]|nil|Creates a new Class from a Table|
|new.*CLASSNAME*(*CLASS ARGS*)|table/class|Create a new Object of a Class|

## Down StringTypes
When a Parameter is written bold then you must use a allowed String. 
Example:
_.serialize(table pTable, string **format**)
```Lua
--Use:
_.serialize( { ... } , "json")
```

**format:**
 - json
 - lua
 
**url**
 -

**wget**
```lua
--wTable example
local wTable = {
	url = "http://example.com", 	--The request URL
	post = { 			--Table for the HTTP Post Parameters
		key = value,
		token = "12345"		--Example Value
	},
	get = {				--Table for URL
		key = value,
		data = "lua"		--Result: "http://example.com?data=lua& <- The last & dosn't matter
	}
	header = {			--HTTP Headers
		key = value,
		User-Agent = "CC",	--Normal your Browser Identy
	}
}
``` 


## Examples
#### _.is*()
```Lua
_.isTable({}) --true
_.isTable(0) --false
_.isString("") --true
_.isString(0) --false
_.isNumber(0) --true
_.isFunction(_.isNumber) -true
_.isFunction(_.isNumber(0)) --false
```

#### _.isEmpty()
```Lua
_.isEmpty({}) --true
_.isEmpty( { 1 } ) --false
_.isEmpty( "" ) --true
_.isEmpty( "nope" ) --false
_.isEmpty() --true
```

#### Class
```Lua
local testClass = {}
function testClass.init(self, pAttribute)
	self.attribute = pAttribute
end
function testClass.sayHey(self)
	print("Hello "..self['attribute'].."!")
end

_.newClass("testClass",testClass)
local test = new.testClass("World")
test.sayHey()
-> "Hello World!"
