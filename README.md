# down
Like jQuery for ComputerCraft. Use _ instead of $. Communtiy based so fork and create pull request.

## Usage:
```lua
--Load down
dofile("down.lua")()
````

## Methods
|Name|return|Desc|
|---|---|---|
|_.import(table pImport)|nil|Import the methods of pImport into _(down)|
|_.wget(string pUrl, [table pPost], [table pHeader])|string|Start a request to pUrl and return the content|
|_.dloadFile(string pUrl, string pFile)|nil|Download the url and put it in pFile|
|_.execUrl(string pUrl, [table fenv] or [_G])|return value of code|
|_.meta(table pTable, [table pMetatable])|table|return metatable of pTable and if pMetatable set new metatable|
|_.putFile(string filename, string content)|nil|Save content into filename|
|_.getFile(string filename)|string/false|Get content of filename|
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

## Examples
### _.is*()
```Lua
_.isTable({}) --true
_.isTable(0) --false
_.isString("") --true
_.isString(0) --false
_.isNumber(0) --true
_.isFunction(_.isNumber) -true
_.isFunction(_.isNumber(0)) --false
```

### _.isEmpty()
```Lua
_.isEmpty({}) --true
_.isEmpty( { 1 } ) --false
_.isEmpty( "" ) --true
_.isEmpty( "nope" ) --false
_.isEmpty() --true
```
