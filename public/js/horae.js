var horae = angular.module('horae', []);

horae.config(function($routeProvider) {
	$routeProvider
	.when('/', {controller:'RouteCtrl', templateUrl:'routes.html'})
	.when('/route/:route_id', {controller:'StopCtrl', templateUrl:'stops.html'})
	.when('/route/:route_id/:origin_id', {controller:'StopCtrl', templateUrl:'stops.html'})
	.when('/status/:route_id/:origin_id/:dest_id', {controller:'StatusCtrl', templateUrl:'status.html'})
	.when('/about', {templateUrl:'about.html'})
	.otherwise({redirectTo:'/'});
});

horae.controller('StatusCtrl', ['$scope', '$http', '$routeParams', '$window', '$location', 
	function StatusCtrl($scope, $http, $routeParams, $window, $location) {

	$scope.$on('$viewContentLoaded', function(event) {
		$window._gaq.push(['_trackPageview', $location.path()]);
	});

	$scope.refresh = function() {
		document.getElementById("loading-overlay").style.display="block";

		$http.get("/live/" + $routeParams.route_id + "/" + $routeParams.origin_id + "/" + $routeParams.dest_id)
		.success(function(data) {
			$scope.statuses = data
			angular.forEach($scope.statuses, function(status) {
				var date = new Date(status.estimated_dpt_time);
				status.format_estimated_date = date.toString("hh:mm tt");
				$scope.formatDateTimeStrings(status);
			});
			document.getElementById("loading-overlay").style.display="none";
		}).error(function() {
			document.getElementById("loading-overlay").style.display="none";
			alert('The service is down :(');
		});
	}

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

	$scope.refresh()
}]);

horae.controller('RouteCtrl', ['$scope', '$http', '$window', '$location', function RouteCtrl($scope, $http, $window, $location) {
	$scope.$on('$viewContentLoaded', function(event) {
		$window._gaq.push(['_trackPageview', $location.path()]);
	});

	$scope.routes = JSON.parse('[{"route_id":"BNSF","route_short_name":"BNSF","route_long_name":"Burlington Northern","route_desc":"","agency_id":"METRA","route_type":"2","route_color":"41E817","route_text_color":"000000","route_url":"http://metrarail.com/Sched/bn/bn.shtml"},{"route_id":"HC","route_short_name":"HC","route_long_name":"Heritage Corridor","route_desc":"","agency_id":"METRA","route_type":"2","route_color":"A80004","route_text_color":"FFFFFF","route_url":"http://metrarail.com/Sched/mhc/mhc.shtml"},{"route_id":"MD-N","route_short_name":"MD-N","route_long_name":"Milwaukee North","route_desc":"","agency_id":"METRA","route_type":"2","route_color":"B5640B","route_text_color":"FFFFFF","route_url":"http://metrarail.com/Sched/md_n/md_n.shtml"},{"route_id":"MD-W","route_short_name":"MD-W","route_long_name":"Milwaukee West","route_desc":"","agency_id":"METRA","route_type":"2","route_color":"F1AD0E","route_text_color":"000000","route_url":"http://metrarail.com/Sched/md_n/md_w.shtml"},{"route_id":"ME","route_short_name":"ME","route_long_name":"Metra Electric","route_desc":"","agency_id":"METRA","route_type":"2","route_color":"F1690E","route_text_color":"000000","route_url":"http://metrarail.com/Sched/me/me.shtml"},{"route_id":"NCS","route_short_name":"NCS","route_long_name":"North Central Service","route_desc":"","agency_id":"METRA","route_type":"2","route_color":"9785BC","route_text_color":"000000","route_url":"http://metrarail.com/Sched/ncs/ncs.shtml"},{"route_id":"RI","route_short_name":"RI","route_long_name":"Rock Island","route_desc":"","agency_id":"METRA","route_type":"2","route_color":"FF0000","route_text_color":"000000","route_url":"http://metrarail.com/Sched/ri/ri.shtml"},{"route_id":"SWS","route_short_name":"SWS","route_long_name":"Southwest Service","route_desc":"","agency_id":"METRA","route_type":"2","route_color":"0561FA","route_text_color":"000000","route_url":"http://metrarail.com/Sched/sws/sws.shtml"},{"route_id":"UP-N","route_short_name":"UP-N","route_long_name":"Union Pacific North","route_desc":"","agency_id":"METRA","route_type":"2","route_color":"008000","route_text_color":"000000","route_url":"http://metrarail.com/Sched/cnw_n/cnwn.shtml"},{"route_id":"UP-NW","route_short_name":"UP-NW","route_long_name":"Union Pacific Northwest","route_desc":"","agency_id":"METRA","route_type":"2","route_color":"FFFF00","route_text_color":"000000","route_url":"http://metrarail.com/Sched/cnw_nw/cnw_nw.shtml"},{"route_id":"UP-W","route_short_name":"UP-W","route_long_name":"Union Pacific West","route_desc":"","agency_id":"METRA","route_type":"2","route_color":"FE8D81","route_text_color":"000000","route_url":"http://metrarail.com/Sched/cnw_w/cnw_w.shtml"}]');
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