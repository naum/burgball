Array::draw = ->
  i = Math.floor Math.random() * this.length
  this[i]

Array::shuffle = ->
  n = this.length
  while n > 0
    i = n - 1
    j = Math.floor(Math.random() * n)
    t = this[i]
    this[i] = this[j]
    this[j] = t
    n -= 1
  true

$.by = (sf, sod=true, sf2=null, sod2=true) ->
  (a, b) ->
    if sf(a) > sf(b)
      if sod then -1 else 1
    else if sf(a) < sf(b)
      if sod then 1 else -1
    else
      if not sf2
        0
      else
        if sf2(a) > sf2(b)
          if sod2 then -1 else 1
        else if sf2(a) < sf2(b)
          if sod2 then 1 else -1
        else 
          0

$.keys = (o) ->
  (k for k, v of o when o.hasOwnProperty(k))


UBA = 
  
  data:
    title: 'Universal Baseball Association'

  genesis: (n=32) ->
    @resetData()
    @data.lidkey = Math.random().toString(36).substr(2, 9)
    tnpool = UBA.team.CITIES.slice 0
    tnpool.shuffle()
    for t in [1..n]
      tn = tnpool.shift()
      UBA.data.teams[tn] = UBA.team.create()
      for p, s of UBA.team.ROSTERSLOTCHART
        for i in [1..s]
          UBA.data.freeagents.push UBA.man.spawn(p, UBA.namepool.draw())
    #@data.freeagents.sort @man.byWorth
    @data.freeagents.sort $.by(@man.worth)
    teamrosterneeds = {}
    for c, t of UBA.data.teams
      teamrosterneeds[c] = UBA.team.needs(c, t)
    tnl = $.keys UBA.data.teams
    while UBA.data.freeagents.length > 0
      fa = UBA.data.freeagents.shift()
      i = 0
      while teamrosterneeds[tnl[i]][fa.pos] == 0
        i += 1
      tn = tnl[i]
      UBA.team.add UBA.data.teams[tn], fa
      teamrosterneeds[tn][fa.pos] -= 1
      tp = (tnl.splice i, 1)[0]
      tnl.push tp
    x = 0
    for c in $.keys(UBA.data.teams)
      @data.standings[c] = UBA.standing.create(x)
      x += 1
    true
    
  man:
    SKILLMARKS: 
      W: ['w', '', 'C', '^', '&#9678;' ]
      K: ['m', '', 'K', '#', '&#8984;' ]
      P: ['n', '', 'P', '!', '&#9732;' ]
      R: ['s', '', 'R', '+', '&#9735;' ]
      G: ['e', '', 'G', '&', '&#10192;' ]
      T: ['x', '', 'T', '@', '&#9773;' ]
    SKILLMATRIX:
      F: [ 'W', 'K', 'P', 'R', 'G', 'T' ]
      H: [ 'W', 'K', 'P', 'R' ]
      P: [ 'W', 'K', 'P', 'G', 'T' ]
    displaySkill: (ss) ->
      s = ''
      s += UBA.man.SKILLMARKS[sk][v] for sk, v of ss
      s
    randSkill: ->
      x = Math.floor Math.random() * 1296
      if x <= 375
        0
      else if x <= 975
        1
      else if x <= 1245
        2
      else if x <= 1293
        3
      else if x <= 1296
        4
    spawn: (p, n) ->
      ss = {}
      sm = if p == 'C' or p == 'I' or p == 'O'
        UBA.man.SKILLMATRIX['F']
      else if p == 'P'
        UBA.man.SKILLMATRIX['P']
      else if p == 'H'
        UBA.man.SKILLMATRIX['H']
      for sk in sm
        ss[sk] = UBA.man.randSkill()
      { name:n, pos:p, age:UBA.man.randSkill(), skill:ss }
    show: (m) ->
      "#{m.pos} #{m.name} #{UBA.man.displaySkill(m.skill)}"
    worth: (m) ->
      sksum = 0
      totsk = 0
      for sk, sv of m.skill
        totsk += 1
        sksum += sv
      Math.floor 100 * sksum / totsk

  namepool:
    draw: ->
      UBA.namepool.replenish() if UBA.data.namepool.length == 0
      UBA.data.namepool.shift()
    replenish:->
      $.ajax '/words.txt'
        async: false
        success: (d) ->
          wordlist = d.split '\n'
          wordlist.shuffle()
          UBA.data.namepool = wordlist.slice 0, 16454

  resetData: ->
    @data.batterstat = {}
    @data.fielderstat = {}
    @data.freeagents = []
    @data.namepool = []
    @data.pitcherstat = {}
    @data.round = 0
    @data.schedule = []
    @data.season = 0
    @data.standings = {}
    @data.teams = {}

  saddle: ->
    if localStorage.getItem('ubadata')
      UBA.data = JSON.parse localStorage.getItem('ubadata')
      true
    else
      false

  standing: 
    create: (i) ->
      { iseed:i, ra:0, w:0, l:0, rf:0, ra:0 } 
    group: (c) ->
      tt = $.keys(UBA.data.standings).length
      UBA.data.standings[c].iseed % (tt / 4)
    pwp: (c) ->
      UBA.data.standings[c].rf / UBA.data.standings[c].ra
    winPct: (c) ->
      UBA.data.standings[c].w / (UBA.data.standings[c].w + UBA.data.standings[c].l)

  stash: ->
    localStorage.setItem 'ubadata', JSON.stringify(UBA.data)

  team:
    CITIES: [
      'New York', 'Los Angeles', 'Chicago', 'Dallas', 'Philadelphia',
      'Houston', 'Washington', 'Miami', 'Atlanta', 'Boston',
      'San Francisco', 'Detroit', 'Riverside', 'Phoenix', 'Seattle',
      'Minneapolis', 'San Diego', 'St. Louis', 'Tampa', 'Baltimore',
      'Denver', 'Pittsburgh', 'Portland', 'Sacramento', 'San Antonio',
      'Orlando', 'Cincinnati', 'Cleveland', 'Kansas City', 'Las Vegas',
      'San Jose', 'Columbus'
    ]
    ROSTERSLOTCHART:
      O:3, I:4, C:1, H:1, P:4
    add: (t, m) ->
      if m.pos != 'P' then t.lineup.push m else t.rotation.push m
    create: ->
      { lineup:[], rotation:[] }
    needs: (c, t) ->
      needchart = {}
      needchart[p] = v for p, v of UBA.team.ROSTERSLOTCHART
      needchart[m.pos] -= 1 for m in t.lineup
      needchart[m.pos] -= 1 for m in t.rotation
      needchart

root = global ? window
root.UBA = UBA

