-- Standalone regression checks: luajit spec/slim/configuration.lua
package.path = 'frontend/?.lua;' .. package.path
package.preload['ffi/util'] = function() return {} end
local Configurable = require('configurable')
local function settings(values)
    return { readSetting = function(_, key) return values[key] end }
end
G_reader_settings = settings({ kopt_text_wrap = 1, kopt_trim_page = 2, kopt_page_opt = 1 })
local options = {prefix = 'kopt', {options = {
    { name = 'text_wrap', default_value = 0 },
    { name = 'trim_page', default_value = 3 },
    { name = 'page_opt', default_value = 0 },
    { name = 'contrast', default_value = 1 },
}}}
local config = Configurable:new{}
config:loadDefaults(options)
assert(config.text_wrap == 0 and config.page_opt == 0 and config.trim_page == 3)
config:loadSettings(settings({kopt_text_wrap=1, kopt_forced_ocr=1, kopt_auto_straighten=5,
    kopt_page_opt=1, kopt_trim_page=1, kopt_contrast=2}), 'kopt_')
assert(config.text_wrap == 0 and config.forced_ocr == 0 and config.auto_straighten == 0)
assert(config.page_opt == 0 and config.trim_page == 3 and config.contrast == 2)
config:loadSettings(settings({kopt_trim_page=0}), 'kopt_')
assert(config.trim_page == 0, 'manual crop must remain available')
local cre = Configurable:new{line_spacing=120}
cre:loadSettings(settings({copt_line_spacing=140}), 'copt_')
assert(cre.line_spacing == 140 and cre.text_wrap == nil, 'EPUB settings must not be changed')
print('Slim configuration regression checks passed')
-- Load the actual option table, with platform services stubbed out.
package.preload['ui/bidi'] = function() return {mirroredUILayout=function() return false end} end
local device = {screen=setmetatable({}, {__index=function() return function(_, value) return value end end})}
setmetatable(device, {__index=function() return function() return false end end})
package.preload['device'] = function() return device end
package.preload['ui/data/isolanguage'] = function() return {} end
package.preload['ui/data/ocr'] = function() return {getOCRLangs=function() return {} end} end
package.preload['ui/data/optionsutil'] = function() return {} end
package.preload['util'] = function() return {} end
package.preload['gettext'] = function()
    return setmetatable({pgettext=function(_, text) return text end}, {__call=function(_, text) return text end})
end
G_defaults = settings(setmetatable({}, {__index=function() return 0 end}))
local kopt = require('ui/data/koptoptions')
local removed = {page_margin=true, auto_straighten=true, line_spacing=true, justification=true,
    font_size=true, font_fine_tune=true, word_spacing=true, white_threshold=true, page_opt=true,
    quality=true, doc_language=true, forced_ocr=true, writing_direction=true, defect_size=true,
    detect_indent=true, max_columns=true}
local seen = {}
for _, tab in ipairs(kopt) do
    local visible = 0
    for _, option in ipairs(tab.options) do
        seen[option.name] = true
        if removed[option.name] then assert(option.show == false, option.name .. ' still exposed') end
        if option.show ~= false then visible = visible + 1 end
        if option.name == 'trim_page' then
            assert(#option.values == 2 and option.values[1] == 3 and option.values[2] == 0)
            assert(option.args[1] == 'none' and option.args[2] == 'manual')
        end
    end
    assert(visible > 0, 'empty bottom-menu tab')
end
for name in pairs(removed) do assert(seen[name], 'missing internal default: ' .. name) end
print('Slim menu availability checks passed')
