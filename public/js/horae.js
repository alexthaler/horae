var horae = angular.module('horae', []);

horae.config(function($routeProvider) {
	$routeProvider
		.when('/', {controller:'RouteCtrl', templateUrl:'routes.html'})
		.when('/route/:route_id', {controller:'StopCtrl', templateUrl:'stops.html'})
		.otherwise({redirectTo:'/'});
});

horae.controller('RouteCtrl', ['$scope', '$http', function RouteCtrl($scope, $http) {
	$http.get("/routes")
	.success(function(data) {
		$scope.routes = data;
	}).error(function() {
		//for now do nothing
	});
}]);

horae.controller('StopCtrl', ['$scope', '$http', '$routeParams', function StopCtrl($scope, $http, $routeParams) {
	$http.get("/routes/" + $routeParams.route_id)
	.success(function(data) {
		console.log('yay route should be populated with ' + data[0]);
		$scope.route = data[0];
	}).error(function() {
		//for now do nothing
	});

	$http.get("/routes/" + $routeParams.route_id + "/stops")
	.success(function(data) {
		$scope.stops = data;
	}).error(function() {
		//skip
	});
}]);