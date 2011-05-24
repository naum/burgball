$(document).ready ->
  UBA.genesis()
  tout = '<table class="rosterchart">'
  UBA.data.freeagents.sort (a, b) ->
    if UBA.man.worth(a) > UBA.man.worth(b)
      -1
    else if UBA.man.worth(a) < UBA.man.worth(b)
      1
    else
      0
  for m in UBA.data.freeagents
    sklit = UBA.man.displaySkill m.skill
    worth = UBA.man.worth m
    jr = 'class="justr"'
    tout += "<tr><td>#{m.pos}<td>#{m.name}<td>#{sklit}<td #{jr}>#{worth}</tr>"
  tout += '</table>'
  $('#mainfield').html tout
  ubadatser = JSON.stringify UBA.data
  $('#dumppanel').html "UBA.data.length = #{ubadatser.length}"


