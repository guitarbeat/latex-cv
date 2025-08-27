-- Convert paragraphs that are entirely bold UPPERCASE text into LaTeX section headings
local utils = require 'pandoc.utils'

function Para(el)
  if #el.content == 1 and el.content[1].t == 'Strong' then
    local txt = utils.stringify(el.content[1])
    local s = txt:gsub('%s+', ' ')
    -- Allow A–Z, digits, spaces and common punctuation seen in headings
    if s:match("^[%u%s&/()'%.%-%d]+$") and #s >= 3 then
      return pandoc.RawBlock('latex', '\\sectionheading{' .. s .. '}')
    end
  end
  return nil
end

