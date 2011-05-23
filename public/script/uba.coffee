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

UBA = 
  
  data:
    freeagents: []
    namepool: []
    teams: []

  man:
    SKILLMARKS: 
      W: ['w', '', 'C', '^', '&#9678;' ]
      K: ['m', '', 'K', '#', '&#8984;' ]
      P: ['n', '', 'P', '!', '&#9732;' ]
      R: ['s', '', 'R', '+', '&#9810;' ]
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
          UBA.data.namepool = wordlist.slice 0, 1000
  team:
    ROSTERSLOTCHART:
      O:3, I:4, C:1, H:1, P:4

root = global ? window
root.UBA = UBA

