class window.TimeFrame
  AVERAGE_DAYS_PER_MONTH = 365.25 / 12
  DATE_FORMAT_REGULAR_EXPRESSION = /(\d{2})\/(\d{4})/

  constructor: (start, end) ->
    @start = @convertToDate(start)
    @end = @convertToDate(end)

  convertToDate: (object) ->
    if object instanceof Date
      object
    else
      @parseDate(object)

  parseDate: (string) ->
    matches = string.match(DATE_FORMAT_REGULAR_EXPRESSION)
    month = parseInt(matches[1])
    year = parseInt(matches[2])
    new Date(year, month - 1)

  length: ->
    # Considers only full months by using the start date's month's first day and the end date's month's last day.
    start = new Date(@start.getFullYear(), @start.getMonth(), 1)
    end = new Date(@end.getFullYear(), @end.getMonth() + 1, 0)
    delta_in_microseconds = end - start
    Math.round(delta_in_microseconds / 1000 / 60 / 60 / 24 / AVERAGE_DAYS_PER_MONTH)

  verbalize: ->
    years = Math.floor(@length() / 12)
    months = @length() % 12

    strings = []
    strings.push('1 year') if years == 1
    strings.push("#{years} years") if years > 1
    strings.push('1 month') if months == 1
    strings.push("#{months} months") if months > 1

    strings.join(', ')
