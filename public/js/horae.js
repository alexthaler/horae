var horae = angular.module('horae', []);

horae.config(function($routeProvider) {
	$routeProvider
	.when('/', {controller:'RouteCtrl', templateUrl:'routes.html'})
	.when('/route/:route_id', {controller:'StopCtrl', templateUrl:'stops.html'})
	.when('/route/:route_id/:origin_id', {controller:'StopCtrl', templateUrl:'stops.html'})
	.when('/status/:route_id/:origin_id/:dest_id', {controller:'StatusCtrl', templateUrl:'status.html'})
	.otherwise({redirectTo:'/'});
});

horae.controller('StatusCtrl', ['$scope', '$http', '$routeParams', '$window', '$location', 
	function StatusCtrl($scope, $http, $routeParams, $window, $location) {

	$scope.$on('$viewContentLoaded', function(event) {
		$window._gaq.push(['_trackPageview', $location.path()]);
	});

	$http.get("/live/" + $routeParams.route_id + "/" + $routeParams.origin_id + "/" + $routeParams.dest_id)
	.success(function(data) {
		$scope.statuses = data
		angular.forEach($scope.statuses, function(status) {
			var date = new Date(status.estimated_dpt_time);
			status.format_estimated_date = date.toString("hh:mm tt");
			$scope.formatDateTimeStrings(status);
		});
	}).error(function() {
		//nothing
	});

	$scope.formatDateTimeStrings = function(status) {
		var est_date = new Date(status.estimated_dpt_time);
		status.fmt_est_date = est_date.toString("h:mm tt");

		var sched_date = new Date(status.scheduled_dpt_time);
		status.fmt_sched_date = sched_date.toString("h:mm tt");

		var numMins = status.eta_min;
		formattedNumMins = numMins%60;
		formattedNumHours = Math.floor(numMins/60);

		if (formattedNumHours != 0) {
			status.formatted_eta = formattedNumHours + " hrs " + formattedNumMins + "mins";
		} else {
			status.formatted_eta = formattedNumMins + " mins";
		}
	}
}]);

horae.controller('RouteCtrl', ['$scope', '$http', '$window', '$location', function RouteCtrl($scope, $http, $window, $location) {
	$scope.$on('$viewContentLoaded', function(event) {
		$window._gaq.push(['_trackPageview', $location.path()]);
	});

	$http.get("/routes")
	.success(function(data) {
		$scope.routes = data;
	}).error(function() {
		//for now do nothing
	});
}]);

horae.controller('StopCtrl', ['$scope', '$http', '$routeParams', '$window', '$location', 
	function StopCtrl($scope, $http, $routeParams, $window, $location) {
	$scope.$on('$viewContentLoaded', function(event) {
		$window._gaq.push(['_trackPageview', $location.path()]);
	});

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

	if ($routeParams.origin_id == undefined) {
		$scope.header_text = 'Select Origin'
	} else {
		$scope.header_text = 'Select Destination'
	}
}]);