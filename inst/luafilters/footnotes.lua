--[[
    weasydoc - Convert R Markdown to PDF Using Weasyprint
    Copyright (C) 2018 Ministère de la Justice, République Française

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
--]]

------------------------------------------------------------------
--   A Pandoc lua filter to implement footnotes as defined in   --
--   the CSS Generated Content for Paged Media Module           --
--   https://www.w3.org/TR/css-gcpm-3/#footnotes                --
--   Note that WeasyPrint does not support these footnotes      --
------------------------------------------------------------------

local List = require 'pandoc.List'

Note = function (elem)
  local inlineElems = List:new{} -- where we store all Inline elements of the footnote
  -- Note is an inline element, so we have to use walk_inline
  pandoc.walk_inline(elem, {
    -- Para is a list of Inline elements, so we can concatenate to inlineElems
    Para = function(el)
      inlineElems:extend(el.content)
      inlineElems:extend(List:new{pandoc.LineBreak()})
    end,
    -- CodeBlock is a block element. We have to store its text content in an inline Code element
    CodeBlock = function(el)
      inlineElems:extend(List:new{pandoc.Code(el.text, el.attr), pandoc.LineBreak()})
    end
  })
  table.remove(inlineElems) -- remove the extra LineBreak
  return pandoc.Span(inlineElems, pandoc.Attr("", {"footnote"}, {}))
end
