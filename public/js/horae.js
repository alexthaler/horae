var horae = angular.module('horae', []);

horae.config(function($routeProvider) {
	$routeProvider
		.when('/', {controller:'RouteCtrl', templateUrl:'routes.html'})
		.when('/route/:route_id', {controller:'StopCtrl', templateUrl:'stops.html'})
		.when('/route/:route_id/:origin_id', {controller:'StopCtrl', templateUrl:'stops.html'})
		.when('/status/:route_id/:origin_id/:dest_id', {controller:'StatusCtrl', templateUrl:'status.html'})
		.otherwise({redirectTo:'/'});
});

horae.controller('StatusCtrl', ['$scope', '$http', '$routeParams', function StatusCtrl($scope, $http, $routeParams) {
	$http.get("/live/" + $routeParams.route_id + "/" + $routeParams.origin_id + "/" + $routeParams.dest_id)
	.success(function(data) {
		$scope.statuses = data
	}).error(function() {
		//nothing
	});
}]);

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

	$scope.generateLink = function(stop) {
		if ($routeParams.origin_id == undefined) {
			return "#/route/" + $routeParams.route_id + "/" + stop.stop_id;
		} else {
			return "#/status/" + $routeParams.route_id + "/" + $routeParams.origin_id + "/" + stop.stop_id;
		}
	}
}]);