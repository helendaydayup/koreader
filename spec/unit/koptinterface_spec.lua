describe("Koptinterface module", function()
    local DocumentRegistry, Koptinterface
    setup(function()
        require("commonrequire")
        DocumentRegistry = require("document/documentregistry")
        Koptinterface = require("document/koptinterface")
    end)

    describe("should", function()

        local doc

        setup(function()
            doc = DocumentRegistry:openDocument("spec/front/unit/data/tall.pdf")
            doc.configurable.text_wrap = 0
        end)

        teardown(function()
            doc:close()
        end)

        -- Slim build: auto/semi-auto bbox (libk2pdfopt) removed, see getPageBBox.

    end)

    describe("should", function()

        local complex_doc

        setup(function()
            complex_doc = DocumentRegistry:openDocument("spec/front/unit/data/sample.pdf")
            complex_doc.configurable.text_wrap = 0
        end)

        teardown(function()
            complex_doc:close()
        end)

        -- Slim build: page block detection (leptonica) removed, returns nil.

        it("should get word from native position", function()
            local word_boxes = Koptinterface:getWordFromPosition(complex_doc, {
                page = 19, x = 400, y = 530,
            })
            assert.is.same("previous", word_boxes.word)
        end)

        -- Slim build: reflow removed, only native position word lookup is tested.

    end)

    describe("should", function()

        local paper_doc

        setup(function()
            paper_doc = DocumentRegistry:openDocument("spec/front/unit/data/paper.pdf")
            paper_doc.configurable.text_wrap = 0
        end)

        teardown(function()
            paper_doc:close()
        end)

        it("should get link from native position", function()
            local link = Koptinterface:getLinkFromPosition(paper_doc, 1, {
                x = 140, y = 560,
            })
            assert.truthy(link)
            assert.is.same(20, link.page)
            require("dbg"):v("link", link)
        end)

        -- Slim build: reflow removed, only native position link lookup is tested.

    end)

end)
