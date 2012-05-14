// Preload images
var ALL_PIN_IMAGE = "/images/pin/allPin.png";

var ALL_IMAGES = [ALL_PIN_IMAGE];

$(function() {
	
	var img_div = document.createElement("div");
	$(img_div).css('display','none');
	
	for (var i=0;i<ALL_IMAGES.length;i++) {
		$(img_div).prepend("<img src='" + ALL_IMAGES[i]+"'>");
	}

	$('body').prepend(img_div);
});


var dot_shadow = new google.maps.MarkerImage(ALL_PIN_IMAGE,
											new google.maps.Size(30, 20),
											new google.maps.Point(416,12),
											new google.maps.Point(2, 20));


var shadow = new google.maps.MarkerImage(ALL_PIN_IMAGE,
										new google.maps.Size(18, 14),
										new google.maps.Point(384,18),
										new google.maps.Point(2, 14));

//var circle_shadow = new google.maps.MarkerImage(ALL_PIN_IMAGE,
//												new google.maps.Size(16, 8),
//												new google.maps.Point(416,57),
//												new google.maps.Point(0, 8));


var red_dot_marker = new google.maps.MarkerImage(ALL_PIN_IMAGE,
													new google.maps.Size(32, 32),
													new google.maps.Point(0,64));
													
var orange_dot_marker = new google.maps.MarkerImage(ALL_PIN_IMAGE,
													new google.maps.Size(32, 32),
													new google.maps.Point(96,0));
													
var green_dot_marker = new google.maps.MarkerImage(ALL_PIN_IMAGE,
													new google.maps.Size(32, 32),
													new google.maps.Point(0,0));
													
var blue_dot_marker = new google.maps.MarkerImage(ALL_PIN_IMAGE,
													new google.maps.Size(32, 32),
													new google.maps.Point(160,0));
													
var d1_dot_marker = new google.maps.MarkerImage(ALL_PIN_IMAGE,
													new google.maps.Size(32, 32),
													new google.maps.Point(0,32));

var d2_dot_marker = new google.maps.MarkerImage(ALL_PIN_IMAGE,
													new google.maps.Size(32, 32),
													new google.maps.Point(64,0));
													
var d3_dot_marker = new google.maps.MarkerImage(ALL_PIN_IMAGE,
													new google.maps.Size(32, 32),
													new google.maps.Point(64,32));
													
var d4_dot_marker = new google.maps.MarkerImage(ALL_PIN_IMAGE,
													new google.maps.Size(32, 32),
													new google.maps.Point(64,64));
													

var red_dot_green_car_marker = new google.maps.MarkerImage(ALL_PIN_IMAGE,
															new google.maps.Size(32, 32),
															new google.maps.Point(64,64));


var orange_dot_green_car_marker = new google.maps.MarkerImage(ALL_PIN_IMAGE,
																new google.maps.Size(32, 32),
																new google.maps.Point(64,32));


var green_dot_green_car_marker = new google.maps.MarkerImage(ALL_PIN_IMAGE,
															new google.maps.Size(32, 32),
															new google.maps.Point(64,0));


var red_dot_red_car_marker = new google.maps.MarkerImage(ALL_PIN_IMAGE,
													new google.maps.Size(32, 32),
													new google.maps.Point(96,64));


var orange_dot_red_car_marker = new google.maps.MarkerImage(ALL_PIN_IMAGE,
													new google.maps.Size(32, 32),
													new google.maps.Point(96,32));


var green_dot_red_car_marker = new google.maps.MarkerImage(ALL_PIN_IMAGE,
													new google.maps.Size(32, 32),
													new google.maps.Point(96,0));


var flagged_red_dot_marker = new google.maps.MarkerImage(ALL_PIN_IMAGE,
															new google.maps.Size(32, 32),
															new google.maps.Point(160 + 0,64));

var flagged_orange_dot_marker = new google.maps.MarkerImage(ALL_PIN_IMAGE,
															new google.maps.Size(32, 32),
															new google.maps.Point(160 + 0,32));

var flagged_green_dot_marker = new google.maps.MarkerImage(ALL_PIN_IMAGE,
															new google.maps.Size(32, 32),
															new google.maps.Point(160 + 0,0));


var flagged_red_dot_green_car_marker = new google.maps.MarkerImage(ALL_PIN_IMAGE,
															new google.maps.Size(32, 32),
															new google.maps.Point(160 + 64,64));


var flagged_orange_dot_green_car_marker = new google.maps.MarkerImage(ALL_PIN_IMAGE,
																new google.maps.Size(32, 32),
																new google.maps.Point(160 + 64,32));


var flagged_green_dot_green_car_marker = new google.maps.MarkerImage(ALL_PIN_IMAGE,
															new google.maps.Size(32, 32),
															new google.maps.Point(160 + 64,0));


var flagged_red_dot_red_car_marker = new google.maps.MarkerImage(ALL_PIN_IMAGE,
													new google.maps.Size(32, 32),
													new google.maps.Point(160 + 96,64));


var flagged_orange_dot_red_car_marker = new google.maps.MarkerImage(ALL_PIN_IMAGE,
													new google.maps.Size(32, 32),
													new google.maps.Point(160 + 96,32));


var flagged_green_dot_red_car_marker = new google.maps.MarkerImage(ALL_PIN_IMAGE,
													new google.maps.Size(32, 32),
													new google.maps.Point(160 + 96,0));


var red_marker = new google.maps.MarkerImage(ALL_PIN_IMAGE,
													new google.maps.Size(20, 20),
													new google.maps.Point(32 + 6, 64 + 12));
													
var orange_marker = new google.maps.MarkerImage(ALL_PIN_IMAGE,
													new google.maps.Size(20, 20),
													new google.maps.Point(32 + 6, 32 + 12));
													
var green_marker = new google.maps.MarkerImage(ALL_PIN_IMAGE,
													new google.maps.Size(20, 20),
													new google.maps.Point(32 + 6, 0 + 12));

var blue_marker = new google.maps.MarkerImage(ALL_PIN_IMAGE,
													new google.maps.Size(20, 20),
													new google.maps.Point(160+ 32 + 6, 0 + 12));
													


var red_circle = new google.maps.MarkerImage(ALL_PIN_IMAGE,
											new google.maps.Size(12, 12),
											new google.maps.Point(320 + 9, 64 + 20),
											new google.maps.Point(6,6));
													
var orange_circle = new google.maps.MarkerImage(ALL_PIN_IMAGE,
											new google.maps.Size(12, 12),
											new google.maps.Point(320 + 9, 32 + 20),
											new google.maps.Point(6,6));
													
var green_circle = new google.maps.MarkerImage(ALL_PIN_IMAGE,
											new google.maps.Size(12, 12),
											new google.maps.Point(320 + 9, 0 + 20),
											new google.maps.Point(6,6));
											
var blue_circle = new google.maps.MarkerImage(ALL_PIN_IMAGE,
											new google.maps.Size(12, 12),
											new google.maps.Point(320+ 32 + 9, 32 + 20),
											new google.maps.Point(6,6));


var old_icons = [{icon:red_circle, shadow:null},
					{icon:orange_circle, shadow:null},
					{icon:green_circle, shadow:null},
					{icon:blue_circle, shadow:null}];

var normal_icons = [{icon:red_marker, shadow:shadow},
					{icon:orange_marker, shadow:shadow},
					{icon:green_marker, shadow:shadow},
					{icon:blue_marker, shadow:shadow}];
					
var new_icons = [{icon:red_dot_marker, shadow:dot_shadow},
					{icon:orange_dot_marker, shadow:dot_shadow},
					{icon:green_dot_marker, shadow:dot_shadow},
					{icon:blue_dot_marker, shadow:dot_shadow},
					{icon:d1_dot_marker, shadow:dot_shadow},
					{icon:d2_dot_marker, shadow:dot_shadow},
					{icon:d3_dot_marker, shadow:dot_shadow},
					{icon:d4_dot_marker, shadow:dot_shadow}
				];
					
var global_flood = {};
global_flood.current_mode = "normal";
global_flood.geocoder = null;
global_flood.map = null;
global_flood.current_location = null;
global_flood.current_bound = new google.maps.LatLngBounds(new google.maps.LatLng(0,0),
															new google.maps.LatLng(0,0)
															);;
global_flood.add_marker = null;
		
global_flood.shown_marker_limit = ($.browser.mobile)? 40:100;	
global_flood.shown_markers = [];	
global_flood.inverse_indices_of_shown_markers = {};

global_flood.query_location_timer_obj = null;

global_flood.current_ajax_request = null;
global_flood.filter = "";
global_flood.q_from = "";
global_flood.q_to = "";

global_flood.abort_ajax_request = function() {
	$("#filter_button").removeClass("loading");
	if (global_flood.current_ajax_request != null) {
		try {
			global_flood.current_ajax_request.abort();
		} catch (e) {}
	}
}


global_flood.clear_query_timer = function() {
	
	if (global_flood.query_location_timer_obj != null)
		clearTimeout(global_flood.query_location_timer_obj);
}


global_flood.set_query_timer = function(timeout) {
	
	if (timeout == undefined) timeout = 5 * 60000;
	
	global_flood.clear_query_timer();
	global_flood.query_location_timer_obj = setTimeout("global_flood.query_location(true);", timeout);
}


global_flood.hide_shown_markers = function() {
	for (var i = 0; i < global_flood.shown_markers.length; i++) {
		global_flood.shown_markers[i].setVisible(false);
	}
}


global_flood.show_shown_markers = function() {
	for (var i = 0; i < global_flood.shown_markers.length; i++) {
		if (global_flood.shown_markers[i].flood_data.data != null) {
			global_flood.shown_markers[i].setVisible(true);
		}
	}
}


global_flood.update_marker_appearance = function(marker, data, force_drop) {

	var previousIcon = marker.getIcon();
					
	if (data.age == "new") {
		marker.setZIndex(((data.is_flagged == true)?3:4));
	} else  if (data.age == "normal") {
		marker.setZIndex(2);
	} else {
		marker.setZIndex(1);
	}
	
	if (data.disease_type == "CHIKUNGUNYA") {
		
		marker.setIcon(new_icons[2].icon);
		marker.setShadow(new_icons[2].shadow);
		
	} else if (data.disease_type == "DENGUE") {
		
		marker.setIcon(new_icons[1].icon);
		marker.setShadow(new_icons[1].shadow);
		
	} else if (data.disease_type == "MALARIA") {
		
		marker.setIcon(new_icons[0].icon);
		marker.setShadow(new_icons[0].shadow);
		
	} else if (data.disease_type == "LEPTOSPIROSIS"){
		
		marker.setIcon(new_icons[3].icon);
		marker.setShadow(new_icons[3].shadow);
		
	}else if (data.disease_type == "D1"){
		
		marker.setIcon(new_icons[4].icon);
		marker.setShadow(new_icons[4].shadow);
		
	}else if (data.disease_type == "D2"){
		
		marker.setIcon(new_icons[5].icon);
		marker.setShadow(new_icons[5].shadow);
		
	}else if (data.disease_type == "D3"){
		
		marker.setIcon(new_icons[6].icon);
		marker.setShadow(new_icons[6].shadow);
		
	}else if (data.disease_type == "D4"){
		
		marker.setIcon(new_icons[7].icon);
		marker.setShadow(new_icons[7].shadow);
	}
	

	if (force_drop == true || previousIcon != marker.getIcon()) {
		marker.setAnimation(google.maps.Animation.DROP);
	}
	
}

global_flood.lazy_initialize_icons = function() {

	if (global_flood.shown_markers.length < global_flood.shown_marker_limit) {
		for(var i=global_flood.shown_markers.length;i<global_flood.shown_marker_limit;i++) {

			var marker = new google.maps.Marker({
												map: global_flood.map,
												visible: false,
												icon: normal_icons[1].icon,
												shadow: normal_icons[1].shadow
												});
			marker.flood_data = {data:null, click_event:null};
			global_flood.shown_markers.push(marker);

		}
	}
}


global_flood.query_location = function(force) {
	
	if (global_flood.current_mode != "normal") return;
	
	global_flood.lazy_initialize_icons();
	
	//var original_bound = global_flood.padding(global_flood.map.getBounds(), 0.05);
	var original_bound = global_flood.map.getBounds();
	
	var bound  = new google.maps.LatLngBounds(new google.maps.LatLng(global_flood.sanitize_position(original_bound.getSouthWest().lat()), global_flood.sanitize_position(original_bound.getSouthWest().lng())),
																new google.maps.LatLng(global_flood.sanitize_position(original_bound.getNorthEast().lat()), global_flood.sanitize_position(original_bound.getNorthEast().lng())));
	
	var northEast = bound.getNorthEast();
	var southWest = bound.getSouthWest();
	
	if (global_flood.consider_equal(northEast.lat(), global_flood.current_bound.getNorthEast().lat())
		&& global_flood.consider_equal(northEast.lng(), global_flood.current_bound.getNorthEast().lng())
		&& global_flood.consider_equal(southWest.lat(), global_flood.current_bound.getSouthWest().lat())
		&& global_flood.consider_equal(southWest.lng(), global_flood.current_bound.getSouthWest().lng())
		&& force != true) {
		return; // We do not query as the position is not changed
	}

	global_flood.clear_query_timer();
	
	global_flood.current_bound = new google.maps.LatLngBounds(new google.maps.LatLng(global_flood.sanitize_position(southWest.lat()), global_flood.sanitize_position(southWest.lng())),
																new google.maps.LatLng(global_flood.sanitize_position(northEast.lat()), global_flood.sanitize_position(northEast.lng())));
	
	var critical = ($('#filter_button').hasClass('critical')?"yes":"no");
	
	var gaqAction = 'Query' + ((critical=="yes")?"Critical":"");
	var gaqData = 'ne=('+northEast.lat()+','+northEast.lng()+'), sw=('+southWest.lat()+','+southWest.lng()+')';
	_gaq.push(['_trackEvent', 'Map', gaqAction, gaqData]);
	
	global_flood.abort_ajax_request();
	$("#filter_button").addClass("loading");
	global_flood.current_ajax_request = $.ajax({
			type: "GET",
			url: '/post',
			cache: false,
			data: {
				ne_lat: global_flood.sanitize_position(northEast.lat()),
				ne_lng: global_flood.sanitize_position(northEast.lng()),
				sw_lat: global_flood.sanitize_position(southWest.lat()),
				sw_lng: global_flood.sanitize_position(southWest.lng()),
				limit: global_flood.shown_marker_limit,
				critical: critical,
				filter: global_flood.filter,
				q_from: global_flood.q_from,
				q_to: global_flood.q_to
			},
			success: function(data){
				
				if (global_flood.current_mode != "normal") return;
				
				if (data.ok != true) return;
				
				if (!global_flood.consider_equal(northEast.lat(), global_flood.current_bound.getNorthEast().lat())) return;
				if (!global_flood.consider_equal(northEast.lng(), global_flood.current_bound.getNorthEast().lng())) return;
				if (!global_flood.consider_equal(southWest.lat(), global_flood.current_bound.getSouthWest().lat())) return;
				if (!global_flood.consider_equal(southWest.lng(), global_flood.current_bound.getSouthWest().lng())) return;
				
				if (critical != ($('#filter_button').hasClass('critical')?"yes":"no")) return;
				
				
				var new_shown_markers = [];
				var empty_markers = [];
				var new_inverse_indices = {};
				
				// Move what is shown and still shown in the next batch
				for (var i = 0; i < data.results.length; i++) {
					var marker = global_flood.inverse_indices_of_shown_markers[data.results[i].id];
					
					if (marker != null) {
						new_shown_markers.push(marker);
						new_inverse_indices[data.results[i].id] = marker;
						
						global_flood.update_marker_appearance(marker, data.results[i]);
					}
				}
				
				// delete old batch
				for (var i=0;i<global_flood.shown_marker_limit;i++) {
					
					if (global_flood.shown_markers[i].flood_data.data == null) {
						empty_markers.push(global_flood.shown_markers[i]);
						continue;
					}
					
					var id = global_flood.shown_markers[i].flood_data.data.id;
					
					if (new_inverse_indices[id] == null) {
						global_flood.shown_markers[i].setVisible(false);
						
						if (global_flood.shown_markers[i].flood_data.click_event != null) {
							google.maps.event.removeListener(global_flood.shown_markers[i].flood_data.click_event);
						}
						
						global_flood.shown_markers[i].flood_data.click_event = null;
						global_flood.shown_markers[i].flood_data.data = null;
						
						empty_markers.push(global_flood.shown_markers[i]);
					}
				}
				
				
				for (var i = 0; i < data.results.length; i++) {
					
					if (new_inverse_indices[data.results[i].id] != null) continue;
					
					var marker = empty_markers.pop();
					
					marker.setPosition(new google.maps.LatLng(data.results[i].location[0], data.results[i].location[1]));
					global_flood.update_marker_appearance(marker, data.results[i], true);
					
					if (marker.flood_data.click_event != null) {
						google.maps.event.removeListener(marker.flood_data.click_event);
					}
					
					marker.setVisible(true);

					marker.flood_data.data = data.results[i];
					marker.flood_data.click_event = google.maps.event.addListener(marker, 'click', function() {
							
																					var self = this;
																					self.setAnimation(google.maps.Animation.BOUNCE);
																							
																					setTimeout(function() {
																						self.setAnimation(null);
																					},1500);
																					
																					if(self.flood_data.data.type == "HotelGroup")
																					{
																						global_flood.hotel_view(self.flood_data.data);
																					}
																					else
																					{
																						global_flood.view(self.flood_data.data);
																					}
																					
																					
																					//global_flood.map.panTo(self.getPosition());
																					
																				});
																				
					new_inverse_indices[data.results[i].id] = marker;
					
				}
				
				global_flood.inverse_indices_of_shown_markers = new_inverse_indices;
				
				if (global_flood.current_mode != "normal") global_flood.hide_shown_markers();

				global_flood.set_query_timer();
				
				$("#filter_button").removeClass("loading");
			},
			error: function(req, status, e){
				if (req.status == 0) return;
				_gaq.push(['_trackEvent', 'Map', 'QueryFailed', '']);
				global_flood.set_query_timer(60000);
				$("#filter_button").removeClass("loading");
			}
		});
}


global_flood.padding = function(bound, portion) {
	
	return bound;
	
	var northEast = bound.getNorthEast();
	var southWest = bound.getSouthWest();
	
	var paddingWidth = Math.abs(northEast.lat() - southWest.lat()) * portion;
	var paddingHeight = Math.abs(northEast.lng() - southWest.lng()) * portion;

	var ret = new google.maps.LatLngBounds(new google.maps.LatLng(global_flood.sanitize_position(southWest.lat() + paddingWidth),
																 global_flood.sanitize_position(southWest.lng() - paddingHeight)),
										new google.maps.LatLng(global_flood.sanitize_position(northEast.lat() - paddingWidth), 
																global_flood.sanitize_position(northEast.lng() + paddingHeight)));

	return ret;
}


global_flood.sanitize_position = function(unit) {
	
	var SIZE = 0.0005;
	var PRECISION = 10000;
    var modulo = parseInt(SIZE * PRECISION);

    var ret = Math.round((unit - (parseInt(Math.round(unit*PRECISION))%modulo)/ PRECISION) * PRECISION)/PRECISION;
	return ret;
}



global_flood.consider_equal = function(a, b) {
	var diff = a - b;
	return (-0.001 < diff && diff < 0.001);
}


global_flood.set_user_geolocation = function(map) {
	
	var zoom = ($.browser.mobile)?14:12;
	if(navigator.geolocation) {

		navigator.geolocation.getCurrentPosition(function(position) {
			var loc = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
			map.setCenter(loc);
			map.setZoom(zoom);
		}, function() {});

	} else if (google.gears) {
		
		var geo = google.gears.factory.create('beta.geolocation');
		geo.getCurrentPosition(function(position) {
		  var loc = new google.maps.LatLng(position.latitude,position.longitude);
		  map.setCenter(loc);
		  map.setZoom(zoom);
		}, function() {});
		
	}

}
		
global_flood.initialize_map = function(zoom, lat, lng) {
			
	global_flood.geocoder = new google.maps.Geocoder();

	var latlng = new google.maps.LatLng(13.723377, 100.476151);
	var myOptions = {
	  zoom: zoom,
	  center: latlng,
	  mapTypeId: google.maps.MapTypeId.ROADMAP,
	  streetViewControl: false,
	  scaleControl: true
	};
	
	global_flood.map = new google.maps.Map(document.getElementById("map"), myOptions);
	
	if (lat == undefined || lng == undefined) {
		global_flood.set_user_geolocation(global_flood.map);
	} else {
		global_flood.map.setCenter(new google.maps.LatLng(lat, lng));
	}
	
	var shadow = new google.maps.MarkerImage(ALL_PIN_IMAGE,
													new google.maps.Size(30, 18),
										      		new google.maps.Point(416,78),
										      		new google.maps.Point(5, 18));
													
	var icon = new google.maps.MarkerImage(ALL_PIN_IMAGE,
													new google.maps.Size(32, 32),
										      		new google.maps.Point(352,0));

	global_flood.add_marker = new google.maps.Marker({
																map: global_flood.map,
																icon: icon,
																shadow: shadow,
																shape: {coords:[0,0,0,0],type:'rect'},
																clickable: false,
																zIndex: 2
															});
	global_flood.add_marker.bindTo('position', global_flood.map, 'center'); 
	global_flood.add_marker.setVisible(false);
	global_flood.current_location = global_flood.map.getCenter();
	

	google.maps.event.addListenerOnce(global_flood.map, 'idle', function(){
		global_flood.query_location(true);
	});
	
	google.maps.event.addListener(global_flood.map, 'click', function(event) {
		global_flood.map.panTo(event.latLng);
	});

		
	google.maps.event.addListener(global_flood.map, 'bounds_changed', function(){
		
		var point = global_flood.map.getCenter();
		global_flood.current_location = new google.maps.LatLng(point.lat(), point.lng());
		
		var local_location = new google.maps.LatLng(global_flood.current_location.lat(), global_flood.current_location.lng());
		
		setTimeout(function() {
			
			if (!global_flood.consider_equal(local_location.lat(), global_flood.current_location.lat())) return;
			if (!global_flood.consider_equal(local_location.lng(), global_flood.current_location.lng())) return;
			
			global_flood.query_location();
		}, 2000);
		
	});

}
	

global_flood.search_for = function(keyword) {
	
	$("#search_address").addClass('searching');
	$('#search_address').blur();
	
	var bangkok_bounds = new google.maps.LatLngBounds(new google.maps.LatLng(13.791660210971326, 99.57502905273441),
														new google.maps.LatLng(14.24467250352153, 101.45094458007816)
														);

	_gaq.push(['_trackEvent', 'Map', 'Search', 'Try']);
	global_flood.geocoder.geocode( { 
									'address': keyword + " ไทย",
									'region':'TH',
									'bounds': bangkok_bounds
									},
									function(results, status) {
										$("#search_address").removeClass('searching');
										if (status != google.maps.GeocoderStatus.OK) return;
										
										_gaq.push(['_trackEvent', 'Map', 'Search', 'Succeeded']);
										
										global_flood.map.panTo(results[0].geometry.location);
										global_flood.map.setZoom(16);
									});

}


global_flood.view = function(post) {
	
	global_flood.current_mode = "view";
	
	var url = "/post/view/id/" + post.id

	$("#dialog").dialog({ title: "View Report" });
	$('#dialog_content').html("<span class='dialogLoading'></span>");
	$('#dialog').dialog('open');
	
	$( "#dialog" ).unbind( "dialogclose");
	$( "#dialog" ).bind( "dialogclose", function(event, ui) {
		global_flood.to_normal_mode();
		$( "#dialog" ).unbind("dialogclose");
	});


	global_flood.abort_ajax_request();
	global_flood.current_ajax_request = $.ajax({
													type: "GET",
													url: url,
													success: function(html){
														
														if (global_flood.current_mode != "view") return;
														$('#dialog_content').html(html);
														
													},
													error: function(req, status, e){
														if (req.status == 0) return;
														req.url = url;
														main_library.log_failed_ajax('/post/view', req, status, e);
														
														$('#dialog_content').html("<span class='loadError'></span>");
													}
												});
	
}


global_flood.to_edit_page = function(post_id) {

	global_flood.current_mode = "edit";

	var url = "/post/edit_form/" + post_id;
	
	$("#dialog").dialog({ title: "Edit" });
	$('#dialog_content').html("<span class='dialogLoading'></span>");
	$('#dialog').dialog('open');
	
	$( "#dialog" ).unbind( "dialogclose");
	$( "#dialog" ).bind( "dialogclose", function(event, ui) {
		global_flood.to_normal_mode(true);
		$( "#dialog" ).unbind("dialogclose");
	});
	
	
	global_flood.abort_ajax_request();
	global_flood.current_ajax_request = $.ajax({
													type: "GET",
													url: url,
													cache: false,
													success: function(html){
														
														if (global_flood.current_mode != "edit") return;
														$('#dialog_content').html(html);
														
													},
													error: function(req, status, e){
														if (req.status == 0) return;
														req.url = url;
														main_library.log_failed_ajax('/post/edit_form', req, status, e);
														
														$('#dialog_content').html("<span class='loadError'></span>");
													}
												});

}

global_flood.to_add_mode = function() {
	
	global_flood.current_mode = "begin_add";
	
	global_flood.add_marker.setVisible(true);
	global_flood.add_marker.setAnimation(google.maps.Animation.DROP);
	
	$('#add_menu').show();
	$('#main_menu').hide();
	$('#search_menu').hide();
	
	global_flood.hide_shown_markers();
	
}

global_flood.to_add_page = function(lat, lng) {

	global_flood.current_mode = "add";

	if (lat == undefined || lng == undefined) {
		var point = global_flood.map.getCenter();
		lat = point.lat();
		lng = point.lng();
	}
	
	var url = "/post/create_form/" + global_flood.sanitize_position(lat) + "/" + global_flood.sanitize_position(lng);
	
	$("#dialog").dialog({ title: "Disease Report" });
	$('#dialog_content').html("<span class='dialogLoading'></span>");
	$('#dialog').dialog('open');
	
	$( "#dialog" ).unbind( "dialogclose");
	$( "#dialog" ).bind( "dialogclose", function(event, ui) {
		global_flood.to_normal_mode(true);
		$( "#dialog" ).unbind("dialogclose");
	});
	
	global_flood.abort_ajax_request();
	global_flood.current_ajax_request = $.ajax({
													type: "GET",
													url: url,
													success: function(html){
														
														if (global_flood.current_mode != "add") return;
														$('#dialog_content').html(html);
													},
													error: function(req, status, e){
														if (req.status == 0) return;
														req.url = url;
														main_library.log_failed_ajax('/post/create_form', req, status, e);
														
														$('#dialog_content').html("<span class='loadError'></span>");
													}
												});

}

global_flood.to_info_page = function() {

	global_flood.current_mode = "help";
	var url = "/help";

	$("#dialog").dialog({ title: "Information" });
	$('#dialog_content').html("<span class='dialogLoading'></span>");
	$('#dialog').dialog('open');
	
	$( "#dialog" ).unbind( "dialogclose");
	$( "#dialog" ).bind( "dialogclose", function(event, ui) {
		global_flood.to_normal_mode();
		$( "#dialog" ).unbind("dialogclose");
	});
	
	global_flood.abort_ajax_request();
	global_flood.current_ajax_request = $.ajax({
													type: "GET",
													url: url,
													success: function(html){
														
														if (global_flood.current_mode != "help") return;
														$('#dialog_content').html(html);
													},
													error: function(req, status, e){
														if (req.status == 0) return;
														req.url = url;
														main_library.log_failed_ajax('/help', req, status, e);
														
														$('#dialog_content').html("<span class='loadError'></span>");
													}
												});
	
}

global_flood.to_normal_mode = function(force) {
	
	global_flood.current_mode = "normal";
	global_flood.add_marker.setVisible(false);
	
	$('#add_menu').hide();
	$('#search_menu').hide();
	$('#main_menu').show();

	global_flood.show_shown_markers();
	global_flood.query_location(force);
	
}


global_flood.to_search_mode = function() {
	
	//global_flood.current_mode = "search";
	_gaq.push(['_trackEvent', 'Map', 'Search', 'ToSearchBox']);
	
	$('#add_menu').hide();
	$('#main_menu').hide();
	$('#search_menu').show();
	
	$('#search_address').val("");
	$('#search_address').focus();
	
}

//global_flood.toggle_filter = function(sender) {
	
//	if ($(sender).hasClass('critical')) {
//		$(sender).removeClass('critical');
//	} else {
//		$(sender).addClass('critical');
//	}
	
//	global_flood.query_location(true);
	
//}

global_flood.to_add_hotel_page = function(lat, lng) {

	global_flood.current_mode = "add";

	if (lat == undefined || lng == undefined) {
		var point = global_flood.map.getCenter();
		lat = point.lat();
		lng = point.lng();
	}
	
	var url = "/hotel/create_form/" + global_flood.sanitize_position(lat) + "/" + global_flood.sanitize_position(lng);
	
	$("#dialog").dialog({ title: "ส่งข่าวที่พัก/อพยพ" });
	$('#dialog_content').html("<span class='dialogLoading'></span>");
	$('#dialog').dialog('open');
	
	$( "#dialog" ).unbind( "dialogclose");
	$( "#dialog" ).bind( "dialogclose", function(event, ui) {
		global_flood.to_normal_mode(true);
		$( "#dialog" ).unbind("dialogclose");
	});
	
	global_flood.abort_ajax_request();
	global_flood.current_ajax_request = $.ajax({
													type: "GET",
													url: url,
													success: function(html){
														
														if (global_flood.current_mode != "add") return;
														$('#dialog_content').html(html);
													},
													error: function(req, status, e){
														if (req.status == 0) return;
														req.url = url;
														main_library.log_failed_ajax('/hotel/create_form', req, status, e);
														
														$('#dialog_content').html("<span class='loadError'></span>");
													}
												});

}	

global_flood.hotel_view = function(post) {
	
	global_flood.current_mode = "view";
	
	var url = "/hotel/view/id/" + post.id

	$("#dialog").dialog({ title: "View Report" });
	$('#dialog_content').html("<span class='dialogLoading'></span>");
	$('#dialog').dialog('open');
	
	$( "#dialog" ).unbind( "dialogclose");
	$( "#dialog" ).bind( "dialogclose", function(event, ui) {
		global_flood.to_normal_mode();
		$( "#dialog" ).unbind("dialogclose");
	});


	global_flood.abort_ajax_request();
	global_flood.current_ajax_request = $.ajax({
													type: "GET",
													url: url,
													success: function(html){
														
														if (global_flood.current_mode != "view") return;
														$('#dialog_content').html(html);
														
													},
													error: function(req, status, e){
														if (req.status == 0) return;
														req.url = url;
														main_library.log_failed_ajax('/hotel/view', req, status, e);
														
														$('#dialog_content').html("<span class='loadError'></span>");
													}
												});
	
}

global_flood.to_edit_hotel_page = function(post_id) {

	global_flood.current_mode = "edit";

	var url = "/hotel/edit_form/" + post_id;
	
	$("#dialog").dialog({ title: "Edit" });
	$('#dialog_content').html("<span class='dialogLoading'></span>");
	$('#dialog').dialog('open');
	
	$( "#dialog" ).unbind( "dialogclose");
	$( "#dialog" ).bind( "dialogclose", function(event, ui) {
		global_flood.to_normal_mode(true);
		$( "#dialog" ).unbind("dialogclose");
	});
	
	
	global_flood.abort_ajax_request();
	global_flood.current_ajax_request = $.ajax({
													type: "GET",
													url: url,
													cache: false,
													success: function(html){
														
														if (global_flood.current_mode != "edit") return;
														$('#dialog_content').html(html);
														
													},
													error: function(req, status, e){
														if (req.status == 0) return;
														req.url = url;
														main_library.log_failed_ajax('/hotel/edit_form', req, status, e);
														
														$('#dialog_content').html("<span class='loadError'></span>");
													}
												});

}

