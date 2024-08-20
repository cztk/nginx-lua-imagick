-- lua/thumb_config.lua
local _M = {
    _VERSION = "0.1",
}

_M.rootDir = "/var/www/html"
_M.privateDir = "/var/www/private"
_M.allowed_dimensions = {
    ["30x30"] = true,
    ["40x40"] = true,
    ["70x100"] = true,
    ["192x275"] = true,
    ["150x100"] = true,
    ["200x300"] = true,
    ["300x200"] = true,
    ["600x400"] = true
}

return _M
