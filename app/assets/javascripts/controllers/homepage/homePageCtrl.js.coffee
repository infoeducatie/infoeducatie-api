class HomePageCtrl
  @$inject: ['$scope', '$sce', '$routeParams', 'News']
  constructor: ($scope, $sce, $routeParams, News) ->
    $scope.news = []

    new News().all().$promise.then( (data) ->
      $scope.news = data
    )

app.controller 'HomePageCtrl', HomePageCtrl
