BRNL = '<br>\n'

highlightMessage = (m) ->
  '<div class="highlight rounded">' + m + '</div>'

logMessage = (m) ->
  $('#dumppanel').append m + BRNL

displayNotYetMessage = (act) ->
  $('#mainfield').html "<h2>#{act}</h2>"
  $('#mainfield').append highlightMessage('Construction time again&hellip;')

displayRosters = ->
  if UBA.saddle() 
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
    $('#mainfield').html '<h2>rosters</h2>' + tout
  else  
    $('#mainfield').html highlightMessage('no league on file')

displayStandings = ->
  if UBA.saddle() 
    jr = 'class="justr"'
    thc = 'class="thead"'
    tout = '<table class="rosterchart">'
    tl = $.keys UBA.data.standings
    tl.sort $.by(UBA.standing.group, false, UBA.standing.winPct, true)
    prevgroup = ''
    for c in tl
      srec = UBA.data.standings[c]
      currgroup = UBA.standing.group(c)
      console.log "c=#{c} currgroup=#{currgroup}"
      if currgroup != prevgroup
        if prevgroup != ''
          tout += '<tr class="blank"><td colspan="5">&nbsp</td></tr>'
        tout += "<tr #{thc}><th>#{currgroup}" +
          "<th #{jr}>W<th #{jr}>L" +
          "<th #{jr}>RF<th #{jr}>RA</th></tr>"
        prevgroup = currgroup
      tout += '<tr>' +
        "<td>#{c}</td>" + 
        "<td #{jr}>#{srec.w}</td>" +
        "<td #{jr}>#{srec.l}</td>" +
        "<td #{jr}>#{srec.rf}</td>" +
        "<td #{jr}>#{srec.ra}</td>" +
        '</tr>'
    tout += '</table>'
    $('#mainfield').html '<h2>standings</h2>' + tout
  else
    $('#mainfield').html highlightMessage('no league on file')

spawnLeague = ->
  UBA.genesis()
  UBA.stash()
  $('#mainfield').html highlightMessage('league created')
  logMessage "UBA.data.lidkey=#{UBA.data.lidkey}"
  logMessage "UBA.data.length=#{JSON.stringify(UBA.data).length}"

DISPATCH_MATRIX = 
  batterstat: displayNotYetMessage
  create: spawnLeague
  fielderstat: displayNotYetMessage
  next: displayNotYetMessage
  pitcherstat: displayNotYetMessage
  rosters: displayRosters
  schedule: displayNotYetMessage
  standings: displayStandings

$(document).ready ->
  $('#mainfield').html '<div class="sitemeta">A GNT creation &copy;2011</div>'
  $('.linkbutton').click ->
    $('#dumppanel').empty()
    act = $(this).text()
    DISPATCH_MATRIX[act].call(null, act)

