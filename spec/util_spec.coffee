describe 'util.coffee', ->
  describe 'Number.prototype.isEven', ->
    it 'is true for even numbers', ->
      expect(0.isEven()).toBeTruthy()

    it 'is false for odd numbers', ->
      expect(1.isEven()).toBeFalsy()
