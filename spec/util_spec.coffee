describe 'util.coffee', ->
  beforeEach (done) ->
    $.ajax(url: 'js/util.js', dataType: 'script').then(done)

  describe 'Number.prototype.isEven', ->
    it 'is true for even numbers', ->
      expect(0.isEven()).toBeTruthy()

    it 'is false for odd numbers', ->
      expect(1.isEven()).toBeFalsy()
