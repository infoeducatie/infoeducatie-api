@app.service 'News', ($resource, $http) ->
  class News
    constructor: () ->
      @service = $resource('/news/:newsId.json', {}, {
        index: {
          method: 'GET',
          params: {},
          isArray: true,
          headers: {
            'Content-Type': 'application/json'
          }
        }
      })
    all: ->
      @service.index()
    find: (newsId) ->
      @service.get({'newsId' : newsId})
