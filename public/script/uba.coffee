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


$.keys = (o) ->
  (k for k, v of o)


UBA = 
  
  data:
    batterstat: {}
    fielderstat: {}
    freeagents: []
    lidkey: null
    namepool: []
    pitcherstat: {}
    schedule: []
    season: 0
    standings: {}
    storekey: null 
    teams: {}
    title: 'Universal Baseball Association'

  genesis: (n=32) ->
    UBA.team.CITIES.shuffle()
    for t in [1..n]
      tn = UBA.team.CITIES.shift()
      UBA.data.teams[tn] = UBA.team.create()
      for p, s of UBA.team.ROSTERSLOTCHART
        for i in [1..s]
          UBA.data.freeagents.push UBA.man.spawn(p, UBA.namepool.draw())
    UBA.data.freeagents.sort UBA.man.byWorth
    teamrosterneeds = {}
    for c, t of UBA.data.teams
      teamrosterneeds[c] = UBA.team.needs(c, t)
    console.log teamrosterneeds
    #teamneedlist.shuffle()
    #while teamneedlist.length > 0
    #  need = teamneedlist.shift()
    #  city = need[0]
    #  i = 0
    #  i += 1 until need[1] == UBA.data.freeagents[i].pos
    #  fa = (UA.data.freeagents.splice i, 1)[0]
    #  UBA.team.add city, fa
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
    byWorth: (a, b) ->
      if UBA.man.worth(a) > UBA.man.worth(b)
        -1
      else if UBA.man.worth(a) < UBA.man.worth(b)
        1
      else
        0
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

