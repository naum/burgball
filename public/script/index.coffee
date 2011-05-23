$(document).ready ->
  men = []
  for t in [1..32]
    for p, s of UBA.team.ROSTERSLOTCHART
      for i in [1..s]
        men.push UBA.man.spawn(p, UBA.namepool.draw())
  tout = '<table class="rosterchart">'
  men.sort (a, b) ->
    if UBA.man.worth(a) > UBA.man.worth(b)
      -1
    else if UBA.man.worth(a) < UBA.man.worth(b)
      1
    else
      0
  for m in men
    sklit = UBA.man.displaySkill m.skill
    worth = UBA.man.worth m
    jr = 'class="justr"'
    tout += "<tr><td>#{m.pos}<td>#{m.name}<td>#{sklit}<td #{jr}>#{worth}</tr>"
  tout += '</table>'
  $('body').append tout


