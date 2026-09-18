-- high level wrapper module for gettext

local _ = require("gettext")

local Language = {
    language_names = {
        C = "English",
        en_GB = "English (United Kingdom)",
        zh_CN = "简体中文",
        zh_TW = "中文（台灣)",
    },
    -- Languages that are written RTL, and should have the UI mirrored.
    -- Should match lang tags defined in harfbuzz/src/hb-ot-tag-table.hh.
    -- https://meta.wikimedia.org/wiki/Template:List_of_language_names_ordered_by_code
    -- Not included are those absent or commented out in hb-ot-tag-table.hh.
    languages_rtl = {
        ar  = true, -- Arabic
        arz = true, -- Egyptian Arabic
        ckb = true, -- Sorani (Central Kurdish)
        dv  = true, -- Divehi
        fa  = true, -- Persian
        he  = true, -- Hebrew
        ks  = true, -- Kashmiri
        ku  = true, -- Kurdish
        ps  = true, -- Pashto
        sd  = true, -- Sindhi
        ug  = true, -- Uyghur
        ur  = true, -- Urdu
        yi  = true, -- Yiddish
    }
}

function Language:getLanguageName(lang_locale)
    return self.language_names[lang_locale] or lang_locale
end

function Language:isLanguageRTL(lang_locale)
    if not lang_locale then
        return false
    end
    local lang = lang_locale
    local sep = lang:find("_")
    if sep then
        lang = lang:sub(1, sep-1)
    end
    return self.languages_rtl[lang] or false
end

function Language:changeLanguage(lang_locale)
    local UIManager = require("ui/uimanager")
    _.changeLang(lang_locale)
    G_reader_settings:saveSetting("language", lang_locale)
    UIManager:askForRestart(_("Please restart KOReader for the new language setting to take effect."))
end

function Language:genLanguageSubItem(lang_locale)
    return {
        text = self:getLanguageName(lang_locale),
        checked_func = function()
            return G_reader_settings:readSetting("language") == lang_locale
        end,
        radio = true,
        callback = function()
            self:changeLanguage(lang_locale)
        end
    }
end

function Language:getLangMenuTable()
    -- cache menu table
    if not self.LangMenuTable then
        self.LangMenuTable = {
            text = _("Language"),
            -- NOTE: language with no translation are commented out for now
            sub_item_table = {
                self:genLanguageSubItem("C"),
                self:genLanguageSubItem("en_GB"),
                self:genLanguageSubItem("zh_CN"),
                self:genLanguageSubItem("zh_TW"),
            }
        }
    end
    return self.LangMenuTable
end

return Language
