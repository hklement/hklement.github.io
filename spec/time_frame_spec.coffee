describe 'time_frame.coffee', ->
  beforeEach (done) ->
    $.ajax(url: 'js/time_frame.js', dataType: 'script').then(done)

  describe 'TimeFrame', ->
    describe 'constructor', ->
      it 'works with Date and String instances', ->
        instance = new TimeFrame(new Date(2016, 0), '02/2016')
        expect(instance).toEqual(jasmine.any(TimeFrame))
        expect(instance.start).toEqual(new Date(2016, 0))
        expect(instance.end).toEqual(new Date(2016, 1))

    describe 'length', ->
      it 'returns the number of months between start date and end date', ->
        instance = new TimeFrame('01/2016', '02/2016')
        expect(instance.length()).toEqual(2)

    describe 'verbalize', ->
      it 'correcly verbalizes time frames shorter than a year', ->
        instance = new TimeFrame('01/2016', '01/2016')
        expect(instance.verbalize()).toEqual('1 month')

      it 'correcly verbalizes time frames longer than a year', ->
        instance = new TimeFrame('01/2016', '10/2017')
        expect(instance.verbalize()).toEqual('1 year, 10 months')
