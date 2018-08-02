ANCHOR_REGEXP = /\[(.+?)\]\((.+?)\)/g
ANIMATION_DURATION = 500
ICON_WIDTH_FRACTION = 0.8
NAVIGATION_BAR_HEIGHT = 45

initialize = ->
  adaptIconWidth()
  handleMailtoLinks()
  scrollSmoothly()
  initializeCollapsedSections()
  loadContent()

adaptIconWidth = ->
  container_width = $('#profiles li').width()
  font_size = Math.round(container_width * ICON_WIDTH_FRACTION)
  $('#profiles i').css('font-size': "#{font_size}px")

handleMailtoLinks = ->
  $(document).on 'click', 'a.mailto', (event) ->
    event.preventDefault()

    obfuscated_email_address = $(event.target).html()
    window.location.assign(buildMailtoLink(obfuscated_email_address))

buildMailtoLink = (obfuscated_email_address) ->
  email_address = obfuscated_email_address.replace(' [at] ', '@').replace(' [dot] ', '.')
  "mailto:#{email_address}"

scrollSmoothly = ->
  $('a.navbar-brand, ul.nav li a').on 'click', (event) ->
    event.preventDefault()

    hash = event.target.hash
    offset = if $(hash).offset() then $(hash).offset().top - NAVIGATION_BAR_HEIGHT else 0

    $('body, html').animate scrollTop: offset, ANIMATION_DURATION, ->
      assignHash(hash)

assignHash = (hash) ->
  if history.pushState && hash
    history.pushState(null, null, hash)
  else
    window.location.hash = hash

initializeCollapsedSections = ->
  $('.collapsed-section .show-more').on 'click', (event) ->
    event.preventDefault()
    $(event.target).parent('.collapsed-section').removeClass('collapsed-section')
    $(event.target).remove()

loadContent = ->
  for section in ['projects', 'studies']
    do (section) ->
      fetchContent(section).then (events) ->
        $("##{section} .show-more").show()
        renderTimeline
          container: $("##{section}")
          events: events.map (event) ->
            event.html = findAndReplaceLinks(event.html)
            event.time_frame = new TimeFrame(event.from, event.to || new Date)
            event

fetchContent = (section) ->
  $.get("/data/#{section}.json")

findAndReplaceLinks = (string) ->
  string.replace ANCHOR_REGEXP, (_, text, url) ->
    "<a href=\"#{url}\" target=\"_blank\">#{text}</a>"

renderTimeline = (options) ->
  timeline = buildTimeline
    events: options.events.sort (a, b) ->
      parseEventTime(b) - parseEventTime(a)

  options.container.children('div.ajax').html(timeline)

parseEventTime = (event) ->
  if event.from
    matches = event.from.match(/\w+/g)
    month = matches[0] - 1
    year = matches[1]
    new Date(year, month).getTime()
  else
    Number.MAX_VALUE

buildTimeline = (options) ->
  list = $('<ul>', class: 'timeline')

  for event, index in options.events
    list.append(buildTimelineItem(event: event, index: index))

  list

buildTimelineItem = (options) ->
  $('<li>', class: 'timeline-inverted' unless options.index.isEven())
    .append(buildTimelineItemBadge(options.event))
    .append(buildTimelineItemPanel(options.event))

buildTimelineItemBadge = (event) ->
  $('<div>', class: 'timeline-badge').append($('<i>', class: event.icon))

buildTimelineItemPanel = (event) ->
  $('<div>', class: 'timeline-panel')
    .append(buildTimelineItemHeading(event))
    .append(buildTimelineItemBody(event))

buildTimelineItemHeading = (event) ->
  $('<div>', class: 'timeline-heading')
    .append(buildTimelineItemTitle(event))
    .append(buildTimelineItemTimeframe(event))
    .append(buildTimelineItemTechnologies(event) if event.technologies)

buildTimelineItemTitle = (event) ->
  $('<h3>', class: 'timeline-title', text: event.title)

buildTimelineItemTimeframe = (event) ->
  dates = [event.from, event.to || 'present']
  html = "<i class=\"fa fa-clock-o\"></i>&nbsp;#{dates.join(' - ')} (#{event.time_frame.verbalize()})"
  $('<p>', class: 'text-muted', html: html)

buildTimelineItemTechnologies = (event) ->
  $('<p>', html: "<i class=\"fa fa-flask\"></i>&nbsp;#{event.technologies}")

buildTimelineItemBody = (event) ->
  $('<div>', class: 'timeline-body', html: event.html)

$(document).ready(initialize)
$(window).on('resize', adaptIconWidth)
