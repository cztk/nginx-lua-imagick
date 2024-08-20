-- lua/thumb/thumb_utils.lua
local ffi = require "ffi_definitions"


local S_IRWXU = tonumber("00700", 8) -- rwx------ (owner)

local _M = {
    _VERSION = "0.1",
}

-- FFI-based file existence check
function _M.file_exists(path)
    -- F_OK is defined as 0 in unistd.h, which checks for existence
    local F_OK = 0
    return ffi.C.access(path, F_OK) == 0
end

-- FFI-based file modification time
function _M.file_modification_time(path)
    local stat_buf = ffi.new("struct s_stat")
    if ffi.C.stat(path, stat_buf) == 0 then
        return tonumber(stat_buf.st_mtime)
    else
        return nil
    end
end

-- FFI-based directory creation for file path
function _M.make_dirs_for_file(path)
    local dir = path:match("(.*/)")
    if dir then
        ffi.C.mkdir(dir, S_IRWXU)
    end
end

function _M.mkdir(path)
    return ffi.C.mkdir(path, S_IRWXU)
end

function _M.file_exists(path)
    local stat_buf = ffi.new("struct s_stat")
    return ffi.C.stat(path, stat_buf) == 0
end

return _M
