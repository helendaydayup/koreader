describe("Cache module", function()
    local DocumentRegistry, DocCache
    local doc
    local max_page = 1
    setup(function()
        require("commonrequire")
        DocumentRegistry = require("document/documentregistry")
        DocCache = require("document/doccache")

        local sample_pdf = "spec/front/unit/data/sample.pdf"
        doc = DocumentRegistry:openDocument(sample_pdf)
    end)
    teardown(function()
        doc:close()
    end)

    it("should clear cache", function()
        DocCache:clear()
    end)

    it("should serialize blitbuffer", function()
        for pageno = 1, math.min(max_page, doc.info.number_of_pages) do
            doc:renderPage(pageno, nil, 1, 0, 1.0, 1.0)
            DocCache:serialize()
        end
        DocCache:clear()
    end)

    it("should deserialize blitbuffer", function()
        for pageno = 1, math.min(max_page, doc.info.number_of_pages) do
            doc:hintPage(pageno, 1, 0, 1.0, 1.0)
        end
        DocCache:clear()
    end)

    it("should serialize koptcontext (slim: koptcontext never created)", function()
        -- Slim build: reflow removed, renderPage always goes through MuPDF,
        -- so no koptcontext ends up in the cache; just exercise serialize.
        for pageno = 1, math.min(max_page, doc.info.number_of_pages) do
            doc:renderPage(pageno, nil, 1, 0, 1.0, 1.0)
            doc:getPageDimensions(pageno, 1, 0)
            DocCache:serialize()
        end
        DocCache:clear()
    end)

    it("should deserialize koptcontext", function()
        for pageno = 1, math.min(max_page, doc.info.number_of_pages) do
            doc:renderPage(pageno, nil, 1, 0, 1.0, 1.0)
        end
        DocCache:clear()
    end)
end)
