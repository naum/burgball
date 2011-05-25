$(document).ready ->
  UBA.genesis()
  tout = '<table class="rosterchart">'
  jr = 'class="justr"'
  thc = 'class="thead"'
  for c, t of UBA.data.teams
    tout += "<tr #{thc}><th>POS<th>#{c.toUpperCase()}<th>SKILL<th #{jr}>WORTH</tr>"
    for m in (t.lineup.concat(t.rotation))
      sklit = UBA.man.displaySkill m.skill
      worth = UBA.man.worth m
      tout += "<tr><td>#{m.pos}<td>#{m.name}<td>#{sklit}<td #{jr}>#{worth}</tr>"
    tout += '<tr class="blank"><td colspan="4">&nbsp;</tr>'
  tout += '</table>'
  $('#mainfield').html tout
  ubadatser = JSON.stringify UBA.data
  $('#dumppanel').html "UBA.data.length = #{ubadatser.length}" + '<br>\n'
  tl = $.keys UBA.data.teams
  $('#dumppanel').append tl.join '<br>\n'



