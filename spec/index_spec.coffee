describe 'index.coffee', ->
  beforeEach (done) ->
    @$container = $('<div>')
    $('body').append(@$container)
    $('<div id="profiles"><ul><li style="width: 100px"><i></i></li></ul></div>').appendTo(@$container)
    $('<div id="studies"><div class="ajax"></div></div>').appendTo(@$container)
    $('<div id="projects"><div class="ajax"></div></div>').appendTo(@$container)

    spyOn($, 'get').and.callThrough()

    loadScript = (path) ->
      $.ajax(url: path, dataType: 'script')

    loadScript('js/time_frame.js').then ->
      loadScript('js/util.js').then ->
        loadScript('js/index.js').then(done)

  afterEach ->
    @$container.remove()

  describe 'when the page is loaded', ->
    it "adjusts the social media icons' width", ->
      expect($('#profiles i').css('font-size')).toEqual('80px')

    it 'fetches JSON content', ->
      for path in ['/data/projects.json', '/data/studies.json']
        expect($.get).toHaveBeenCalledWith(path)

    it 'renders timelines based on the fetched content', ->
      for $container in [$('#projects'), $('#studies')]
        expect($container.find('ul.timeline').length).toEqual(1)
        expect($container.find('ul.timeline li .timeline-badge').length).toBeGreaterThan(1)
        expect($container.find('ul.timeline li .timeline-panel .timeline-heading').length).toBeGreaterThan(1)
        expect($container.find('ul.timeline li .timeline-panel .timeline-body').length).toBeGreaterThan(1)

    it 'sorts timeline items by recency', ->
      parseDate = ($item) ->
        matches = $item.html().match(/(\d{2})\/(\d{4})/)
        month: parseInt(matches[1]), year: parseInt(matches[2])

      for $container in [$('#projects'), $('#studies')]
        for item in $container.find('ul.timeline li:not(:last)')
          date = parseDate($(item))
          successor_date = parseDate($(item).next())
          ordered_correctly = date.year > successor_date.year ||
                              (date.year == successor_date.year && date.month >= successor_date.month)
          expect(ordered_correctly).toBe(true)

    it 'places timeline items on alternating sides', ->
      for $container in [$('#projects'), $('#studies')]
        number_of_items = $container.find('ul.timeline li').length
        number_of_items_on_the_left = $container.find('ul.timeline li.timeline-inverted').length
        expect(number_of_items_on_the_left).toEqual(Math.floor(number_of_items / 2))

  describe 'when an obfuscated email address is clicked', ->
    beforeEach ->
      @$anchor = $('<a>', class: 'mailto', text: 'mail [at] example [dot] com')
      @$container.append(@$anchor)

    it 'builds a working mailto link', ->
      spyOn(window.location, 'assign')
      @$anchor.trigger('click')
      expect(window.location.assign).toHaveBeenCalledWith('mailto:mail@example.com')
