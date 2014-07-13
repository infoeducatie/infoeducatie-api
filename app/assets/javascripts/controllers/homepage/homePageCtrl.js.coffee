class HomePageCtrl
  @$inject: ['$scope', '$sce', '$routeParams']
  constructor: ($scope, $sce, $routeParams) ->
    console.log("Hai salut!")

app.controller 'HomePageCtrl', HomePageCtrl
