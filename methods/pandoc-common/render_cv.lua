local utils = require 'pandoc.utils'
local List = pandoc.List

local function text(s)
  return pandoc.Str(s)
end

local function plain(s)
  return pandoc.Para({ pandoc.Str(s) })
end

local function rawlatex(s)
  return pandoc.RawInline('latex', s)
end

local function rawblock(s)
  return pandoc.RawBlock('latex', s)
end

-- Convert inline list to LaTeX string
local function latex_of_inlines(inlines)
  local doc = pandoc.Pandoc({ pandoc.Plain(inlines) })
  local s = pandoc.write(doc, 'latex') or ''
  -- trim trailing newlines
  return (s:gsub('%s+$',''))
end

-- Build a two-column left/right line using tabular* with fixed column widths
local function two_col_line(left_inlines, right_inlines, lw, rw)
  lw = lw or '0.78\\textwidth'
  rw = rw or '0.20\\textwidth'
  local ltx = latex_of_inlines(left_inlines)
  local rtx = latex_of_inlines(right_inlines)
  local tbl = table.concat({
    '\\noindent\\begin{tabular*}{\\textwidth}{@{}p{', lw, '} p{', rw, '}@{}}',
    ltx, ' & ', rtx, '\\\\',
    '\\end{tabular*}'
  })
  return rawblock(tbl)
end

-- Parse a Markdown string into inline elements
local function md_inlines(s)
  if not s or s == '' then return List{} end
  local doc = pandoc.read(s, 'markdown')
  local inls = List{}
  for _,b in ipairs(doc.blocks) do
    if b.t == 'Para' or b.t == 'Plain' then
      for _,i in ipairs(b.content) do inls:insert(i) end
    end
  end
  return inls
end

local function tex_escape(s)
  s = s:gsub('\\', '\\textbackslash{}')
  s = s:gsub('([#%%$&_{}])', '\\%1')
  s = s:gsub('~', '\\textasciitilde{}')
  s = s:gsub('%^', '\\textasciicircum{}')
  return s
end

local function section(title)
  return rawblock('\\sectionheading{' .. tex_escape(title) .. '}')
end

-- Header rendering is handled by the pandoc template using metadata

local function add_education(meta)
  local blocks = List{}
  if not meta.education then return blocks end
  blocks:insert(section('Education'))
  for _,e in ipairs(meta.education) do
    local degree = utils.stringify(e.degree or '')
    local inst = utils.stringify(e.institution or '')
    local date = utils.stringify(e.date or '')
    local right = utils.stringify(e.right or '')
    local note = utils.stringify(e.note or '')
    -- Degree (bold) | date (italic)
    local left1 = md_inlines('**' .. degree .. '**')
    local right1 = date ~= '' and md_inlines('*' .. date .. '*') or List{}
    blocks:insert(two_col_line(left1, right1, '0.75\\textwidth', '0.23\\textwidth'))
    -- Institution (italic) | right detail (italic)
    local left2 = md_inlines('*' .. inst .. '*')
    local right2 = md_inlines(right)
    blocks:insert(two_col_line(left2, right2, '0.75\\textwidth', '0.23\\textwidth'))
    blocks:insert(rawblock('\\vspace{0.6ex}'))
    if note ~= '' then blocks:insert(pandoc.Para(md_inlines(note))) end
  end
  return blocks
end

local function add_publications_and_patents(meta)
  local blocks = List{}
  local pubs = {}
  if meta.publications then
    for _,p in ipairs(meta.publications) do table.insert(pubs, utils.stringify(p)) end
  end
  if meta.patents then
    for _,p in ipairs(meta.patents) do table.insert(pubs, utils.stringify(p)) end
  end
  if #pubs == 0 then return blocks end
  local label = 'Publications'
  if meta.labels and meta.labels.publications_section then
    label = utils.stringify(meta.labels.publications_section)
  end
  blocks:insert(section(label))
  for _,p in ipairs(pubs) do
    blocks:insert(pandoc.Para(md_inlines(p)))
  end
  return blocks
end

local function role_para(title, org, sub, date)
  local left = List{}
  if title ~= '' then for _,i in ipairs(md_inlines('**' .. title .. '**')) do left:insert(i) end end
  if org ~= '' then
    if #left > 0 then left:insert(pandoc.Str(', ')) end
    for _,i in ipairs(md_inlines(org)) do left:insert(i) end
  end
  local right = md_inlines(date)
  local lines = List{ two_col_line(left, right, '0.77\\textwidth', '0.23\\textwidth') }
  if sub ~= '' then
    lines:insert(rawblock('\\vspace{0.3ex}'))
    lines:insert(pandoc.Para(md_inlines(sub)))
  end
  lines:insert(rawblock('\\vspace{0.6ex}'))
  return lines
end

local function bullets_from(list)
  local items = List{}
  for _,b in ipairs(list or {}) do
    items:insert(pandoc.Plain(md_inlines(utils.stringify(b))))
  end
  return items
end

local function add_research_experience(meta)
  local blocks = List{}
  if not meta.research_experience then return blocks end
  blocks:insert(section('Research Experience'))
  for _,r in ipairs(meta.research_experience) do
    local title = utils.stringify(r.title or '')
    local org = utils.stringify(r.org or '')
    local sub = utils.stringify(r.sub or '')
    local date = utils.stringify(r.date or '')
    for _,b in ipairs(role_para(title, org, sub, date)) do blocks:insert(b) end
    if r.bullets then
      blocks:insert(pandoc.BulletList(bullets_from(r.bullets)))
    end
  end
  return blocks
end

local function add_funding(meta)
  local blocks = List{}
  if not meta.research_funding then return blocks end
  blocks:insert(section('Research Funding'))
  for _,f in ipairs(meta.research_funding) do
    local label = utils.stringify(f.label or '')
    local date = utils.stringify(f.date or '')
    local note = utils.stringify(f.note or '')
    local inlines = md_inlines(label)
    if date ~= '' then inlines:insert(rawlatex(' \\hfill ' .. date)) end
    blocks:insert(pandoc.Para(inlines))
    if note ~= '' then blocks:insert(pandoc.Para(md_inlines(note))) end
  end
  return blocks
end

local function add_simple_list_section(meta, key, title)
  local blocks = List{}
  local lst = meta[key]
  if not lst then return blocks end
  blocks:insert(section(title))
  local items = List{}
  for _,p in ipairs(lst) do
    items:insert(pandoc.Plain(md_inlines(utils.stringify(p.text or p))))
  end
  blocks:insert(pandoc.BulletList(items))
  return blocks
end

local function add_academic_appointments(meta)
  local blocks = List{}
  if not meta.academic_appointments then return blocks end
  blocks:insert(section('Academic Appointments'))
  for _,a in ipairs(meta.academic_appointments) do
    local label = utils.stringify(a.label or '')
    local org = utils.stringify(a.org or '')
    local date = utils.stringify(a.date or '')
    local inlines = List{ pandoc.Strong(md_inlines(label)) }
    if org ~= '' then
      inlines:insert(pandoc.Str(' '))
      for _,i in ipairs(md_inlines(org)) do inlines:insert(i) end
    end
    if date ~= '' then inlines:insert(rawlatex(' \\hfill ' .. date)) end
    blocks:insert(pandoc.Para(inlines))
  end
  return blocks
end

local function add_teaching(meta)
  local blocks = List{}
  if not meta.teaching_experience then return blocks end
  blocks:insert(section('Teaching Experience'))
  for _,t in ipairs(meta.teaching_experience) do
    for _,b in ipairs(role_para(utils.stringify(t.title or ''), utils.stringify(t.org or ''), utils.stringify(t.sub or ''), utils.stringify(t.date or ''))) do blocks:insert(b) end
    if t.bullets then blocks:insert(pandoc.BulletList(bullets_from(t.bullets))) end
  end
  return blocks
end

local function add_honors(meta)
  local blocks = List{}
  if not meta.honors_awards then return blocks end
  blocks:insert(section('Honors & Awards'))
  for _,h in ipairs(meta.honors_awards) do
    local label = utils.stringify(h.label or '')
    local date = utils.stringify(h.date or '')
    local note = utils.stringify(h.note or '')
    local inlines = md_inlines(label)
    if date ~= '' then inlines:insert(rawlatex(' \\hfill ' .. date)) end
    blocks:insert(pandoc.Para(inlines))
    if note ~= '' then blocks:insert(pandoc.Para(md_inlines(note))) end
  end
  return blocks
end

local function add_service(meta)
  local blocks = List{}
  if not meta.academic_service then return blocks end
  blocks:insert(section('Academic Service'))
  for _,s in ipairs(meta.academic_service) do
    if s.title then
      for _,b in ipairs(role_para(utils.stringify(s.title or ''), utils.stringify(s.org or ''), utils.stringify(s.sub or ''), utils.stringify(s.date or ''))) do blocks:insert(b) end
      if s.bullets then blocks:insert(pandoc.BulletList(bullets_from(s.bullets))) end
    elseif s.simple then
      local items = List{}
      for _,line in ipairs(s.simple) do items:insert(pandoc.Plain(md_inlines(utils.stringify(line)))) end
      blocks:insert(pandoc.BulletList(items))
    end
  end
  return blocks
end

local function add_professional(meta)
  local blocks = List{}
  if not meta.professional_experience then return blocks end
  blocks:insert(section('Professional Experience'))
  for _,p in ipairs(meta.professional_experience) do
    if p.title then
      local title = utils.stringify(p.title or '')
      local org = utils.stringify(p.org or '')
      local date = utils.stringify(p.date or '')
      local desc = utils.stringify(p.desc or '')
      for _,b in ipairs(role_para(title, org, '', date)) do blocks:insert(b) end
      if desc ~= '' then blocks:insert(pandoc.Para(md_inlines(desc))) end
    elseif p.simple then
      local items = List{}
      for _,line in ipairs(p.simple) do items:insert(pandoc.Plain(md_inlines(utils.stringify(line)))) end
      blocks:insert(pandoc.BulletList(items))
    end
  end
  return blocks
end

function Pandoc(doc)
  local meta = doc.meta
  local blocks = List{}
  for _,b in ipairs(add_education(meta)) do blocks:insert(b) end
  for _,b in ipairs(add_publications_and_patents(meta)) do blocks:insert(b) end
  for _,b in ipairs(add_research_experience(meta)) do blocks:insert(b) end
  for _,b in ipairs(add_funding(meta)) do blocks:insert(b) end
  for _,b in ipairs(add_academic_appointments(meta)) do blocks:insert(b) end
  for _,b in ipairs(add_teaching(meta)) do blocks:insert(b) end
  for _,b in ipairs(add_honors(meta)) do blocks:insert(b) end
  for _,b in ipairs(add_simple_list_section(meta, 'posters', 'Poster Presentations')) do blocks:insert(b) end
  for _,b in ipairs(add_service(meta)) do blocks:insert(b) end
  for _,b in ipairs(add_professional(meta)) do blocks:insert(b) end
  for _,b in ipairs(add_simple_list_section(meta, 'conferences', 'Conference Participation')) do blocks:insert(b) end
  return pandoc.Pandoc(blocks, meta)
end
