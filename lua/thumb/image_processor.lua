-- lua/thumb/image_processor.lua
local magick = require "magick"
local config = require "thumb_config"
local utils = require "thumb_utils"

local _M = {
    _VERSION = "0.1",
}

function _M.process_image(width, height, filename, ext, quality)
    if not width or not height or not (height == 30 or config.allowed_dimensions[width .. "x" .. height]) then
        ngx.status = 403
        ngx.say("not allowed")
        return
    end

    local input_image = config.privateDir .. "/images/" .. filename .. "." .. ext

    if not utils.file_exists(input_image) then
        local first_folder = filename:match("([^/]+)/")
        if first_folder then
            ext = "webp"
            input_image = config.privateDir .. "/replacement_images/" .. first_folder .. "/default." .. ext
        end
    end

    local accept_header = ngx.var.http_accept
    local output_format = "jpeg"

    if accept_header then
        if accept_header:find("image/webp") or accept_header:find("*/*") then
            output_format = "webp"
        elseif accept_header:find("image/png") then
            output_format = "png"
        end
    end

    local output_image_dir = config.rootDir .. "/thumb/" .. width .. "x" .. height
    local output_image_name = filename .. "." .. output_format
    local output_image = output_image_dir .. "/" .. output_image_name

    -- Use FFI-based directory creation
    utils.make_dirs_for_file(output_image)

    local regenerate_thumb = true

    -- Use FFI-based file existence check and modification time check
    if utils.file_exists(output_image) then
        local input_mod_time = utils.file_modification_time(input_image)
        local output_mod_time = utils.file_modification_time(output_image)
        if output_mod_time and input_mod_time and output_mod_time >= input_mod_time then
            regenerate_thumb = false
        end
    end

    if regenerate_thumb then
        local img, err = magick.load_image(input_image)
        if not img then
            ngx.status = 500
            ngx.say("Failed to load image: " .. (err or "unknown error"))
            return
        end
        img:resize(width, height)
        img:set_quality(quality)
        img:strip()
        local success, write_err = img:write(output_image)
        if not success then
            ngx.status = 500
            ngx.say("Failed to write image: " .. (write_err or "unknown error"))
            return
        end
    end

    ngx.header.content_type = "image/" .. output_format
    -- fastly cdn
    -- ngx.header.surrogate_control = "public, max-age=86400"
    ngx.header.cache_control = "public, max-age=86400, immutable"
    ngx.header.access_control_allow_methods = 'GET, HEAD, OPTIONS'
    ngx.header.access_control_allow_origin = "*"

    local file = io.open(output_image, "rb")
    local content = file:read("*all")
    file:close()
    ngx.say(content)
end

return _M
