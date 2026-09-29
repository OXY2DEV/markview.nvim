local ffi = require("ffi")

ffi.cdef[[
    int latex_register_symbols(const char *const *names, const char *const *values, unsigned int count);
    char* latex_to_unicode(const char* input);
    char* latex_to_unicode_block(const char* input);
    char* latex_to_unicode_checked(const char* input, int* fully_supported);
    char* latex_to_unicode_block_checked(const char* input, int* fully_supported);
    char* latex_transform_markdown(const char* input);
    void latex_unicode_free(char* ptr);
]]

local M = {}
local lib = nil
local symbols_registered = false

local function get_lib_path()
    local home = os.getenv("HOME")
    local candidates = {
        home .. "/Labs/KpihX-Labs/latex-to-unicode/target/release/liblatex_to_unicode_c_api.so",
        home .. "/.local/lib/liblatex_to_unicode_c_api.so",
        "/usr/local/lib/liblatex_to_unicode_c_api.so",
    }
    for _, path in ipairs(candidates) do
        local f = io.open(path, "r")
        if f then
            f:close()
            return path
        end
    end
    return nil
end

local function register_markview_symbols()
    local entries = require("markview.symbols").entries
    local names = {}

    for name, value in pairs(entries) do
        if type(name) == "string" and type(value) == "string" then
            table.insert(names, name)
        end
    end

    table.sort(names)
    if #names == 0 then
        return false, "Markview symbol table is empty"
    end

    local name_buffers, value_buffers = {}, {}
    local name_pointers = ffi.new("const char *[?]", #names)
    local value_pointers = ffi.new("const char *[?]", #names)

    for i, name in ipairs(names) do
        local value = entries[name]
        local name_buffer = ffi.new("char[?]", #name + 1)
        local value_buffer = ffi.new("char[?]", #value + 1)
        ffi.copy(name_buffer, name, #name)
        ffi.copy(value_buffer, value, #value)
        name_buffers[i] = name_buffer
        value_buffers[i] = value_buffer
        name_pointers[i - 1] = name_buffer
        value_pointers[i - 1] = value_buffer
    end

    -- Keep the pointed-to buffers alive until Rust has copied the table.
    local registered = lib.latex_register_symbols(name_pointers, value_pointers, #names)
    if registered ~= 1 then
        return false, "Rust backend rejected Markview's symbol table"
    end
    return true
end

function M.init()
    if not lib then
        local path = get_lib_path()
        if not path then
            return false, "liblatex_to_unicode_c_api.so not found"
        end
        local ok, loaded = pcall(ffi.load, path)
        if not ok then
            return false, loaded
        end
        lib = loaded
    end

    if not symbols_registered then
        local ok, registered, err = pcall(register_markview_symbols)
        if not ok then
            return false, registered
        end
        if not registered then
            return false, err
        end
        symbols_registered = true
    end

    return true
end

local function convert(latex_str, block)
    if not M.init() then return latex_str, false end
    local fully_supported = ffi.new("int[1]")
    local c_str
    if block then
        c_str = lib.latex_to_unicode_block_checked(latex_str, fully_supported)
    else
        c_str = lib.latex_to_unicode_checked(latex_str, fully_supported)
    end
    if c_str == nil then return latex_str, false end
    local res = ffi.string(c_str)
    lib.latex_unicode_free(c_str)
    return res, fully_supported[0] ~= 0
end

function M.to_unicode(latex_str)
    return convert(latex_str, false)
end

function M.to_unicode_block(latex_str)
    return convert(latex_str, true)
end

function M.transform_markdown(md_str)
    if not M.init() then return md_str end
    local c_str = lib.latex_transform_markdown(md_str)
    if c_str == nil then return md_str end
    local res = ffi.string(c_str)
    lib.latex_unicode_free(c_str)
    return res
end

return M
