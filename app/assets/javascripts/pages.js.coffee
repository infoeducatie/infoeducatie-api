#= require_self
#= require_tree ./controllers/homepage
#= require_tree ./directives
#= require_tree ./services
#= require_tree ./templates

@app = angular.module('infoeducatie', [ 'ngRoute', 'ngResource', 'ngAnimate' ])

@app.config(['$routeProvider', '$locationProvider', (routeProvider, locationProvider) ->
  routeProvider.when('/', {
    templateUrl: '/assets/templates/homepage/index.html',
    controller: 'HomePageCtrl'
  }).otherwise({ redirectTo: '/' })
])
