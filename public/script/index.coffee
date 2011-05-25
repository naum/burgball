$(document).ready ->
  UBA.genesis()
  tout = '<table class="rosterchart">'
  UBA.data.freeagents.sort UBA.man.byWorth
  for m in UBA.data.freeagents
    sklit = UBA.man.displaySkill m.skill
    worth = UBA.man.worth m
    jr = 'class="justr"'
    tout += "<tr><td>#{m.pos}<td>#{m.name}<td>#{sklit}<td #{jr}>#{worth}</tr>"
  tout += '</table>'
  $('#mainfield').html tout
  ubadatser = JSON.stringify UBA.data
  $('#dumppanel').html "UBA.data.length = #{ubadatser.length}" + '<br>\n'
  tl = $.keys UBA.data.teams
  $('#dumppanel').append tl.join '<br>\n'



