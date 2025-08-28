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
    -- First line: degree left, date right
    local inlines = List{}
    if degree ~= '' then inlines:insert(pandoc.Strong(pandoc.Str(degree))) end
    if date ~= '' then inlines:insert(rawlatex(' \\hfill ' .. date)) end
    blocks:insert(pandoc.Para(inlines))
    -- Second line: institution left, right detail right
    local inlines2 = List{ pandoc.Emph(pandoc.Str(inst)) }
    if right ~= '' then inlines2:insert(rawlatex(' \\hfill ' .. right)) end
    blocks:insert(pandoc.Para(inlines2))
    if note ~= '' then blocks:insert(plain(note)) end
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
  local items = List{}
  for _,p in ipairs(pubs) do
    items:insert(pandoc.Plain({ pandoc.Str(p) }))
  end
  blocks:insert(pandoc.BulletList(items))
  return blocks
end

local function role_para(title, org, sub, date)
  local inlines = List{}
  if title ~= '' then
    inlines:insert(pandoc.Strong(pandoc.Str(title)))
  end
  if org ~= '' then
    if #inlines > 0 then inlines:insert(pandoc.Str(', ')) end
    inlines:insert(pandoc.Str(org))
  end
  if date ~= '' then inlines:insert(rawlatex(' \\hfill ' .. date)) end
  local p = pandoc.Para(inlines)
  local lines = List{ p }
  if sub ~= '' then lines:insert(plain(sub)) end
  return lines
end

local function bullets_from(list)
  local items = List{}
  for _,b in ipairs(list or {}) do
    items:insert(pandoc.Plain({ pandoc.Str(utils.stringify(b)) }))
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
    local inlines = List{ pandoc.Str(label) }
    if date ~= '' then inlines:insert(rawlatex(' \\hfill ' .. date)) end
    blocks:insert(pandoc.Para(inlines))
    if note ~= '' then blocks:insert(plain(note)) end
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
    items:insert(pandoc.Plain({ pandoc.Str(utils.stringify(p.text or p)) }))
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
    local inlines = List{ pandoc.Strong(pandoc.Str(label)) }
    if org ~= '' then
      inlines:insert(pandoc.Str(' '))
      inlines:insert(pandoc.Str(org))
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
    local inlines = List{ pandoc.Str(label) }
    if date ~= '' then inlines:insert(rawlatex(' \\hfill ' .. date)) end
    blocks:insert(pandoc.Para(inlines))
    if note ~= '' then blocks:insert(plain(note)) end
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
      for _,line in ipairs(s.simple) do items:insert(pandoc.Plain({ pandoc.Str(utils.stringify(line)) })) end
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
      if desc ~= '' then blocks:insert(plain(desc)) end
    elseif p.simple then
      local items = List{}
      for _,line in ipairs(p.simple) do items:insert(pandoc.Plain({ pandoc.Str(utils.stringify(line)) })) end
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
