// Preload images


var global_flood = {};

global_flood.map = null;
global_flood.current_location = null;
global_flood.current_bound = new google.maps.LatLngBounds(new google.maps.LatLng(0,0),
															new google.maps.LatLng(0,0)
															);

global_flood.shown_marker_limit = 300;
global_flood.shown_markers = [];	

global_flood.current_ajax_request = null;

global_flood.start_loading = function() {
	$('#map_loading').show();
}

global_flood.stop_loading = function() {
	$('#map_loading').hide();
}

global_flood.abort_ajax_request = function() {
	global_flood.stop_loading();
	if (global_flood.current_ajax_request != null) {
		try {
			global_flood.current_ajax_request.abort();
		} catch (e) {}
	}
}




global_flood.update_marker_appearance = function(marker, data, color) {

	marker.setBounds(new google.maps.LatLngBounds(new google.maps.LatLng(data.location[0] - 0.01, data.location[1] - 0.01),
													new google.maps.LatLng(data.location[0] + 0.01, data.location[1] + 0.01)));
	
	marker.setOptions({fillColor: "#"+color,
						strokeColor: "#"+color})
	
	marker.label.bound = new google.maps.LatLngBounds(new google.maps.LatLng(data.location[0] - 0.01, data.location[1] - 0.01),
													new google.maps.LatLng(data.location[0] + 0.01, data.location[1] + 0.01));
	
	var zoom = global_flood.map.getZoom();
	marker.label.zoom = zoom;

	if (zoom >= 12) {
		marker.label.set('text', data.name + " (" + data.score + ")");
	} else if (zoom > 10)  {
		marker.label.set('text', data.score + "");
	} else {
		marker.label.set('text', "");
	}
	
	marker.label.set('position', new google.maps.LatLng(data.location[0] + 0.01, data.location[1] - 0.01));
	marker.show();
	
	//marker.setAnimation(google.maps.Animation.DROP);
}

global_flood.initialize_icons = function() {

		
	for(var i=global_flood.shown_markers.length;i<global_flood.shown_marker_limit;i++) {

  		var marker = new google.maps.Rectangle();

	    var rectOptions = {
	      strokeColor: "#FF0000",
	      strokeOpacity: 0.8,
	      strokeWeight: 1,
	      fillColor: "#FF0000",
	      fillOpacity: 0.35,
	      map: null,
	      bounds: null
	    };
		
		marker.label = new Label({
									map: global_flood.map
								});
		marker.label.bound = new google.maps.LatLngBounds(new google.maps.LatLng(0, 0),
															new google.maps.LatLng(0, 0));
		marker.label.set('text', "");
		marker.label.set('position', new google.maps.LatLng(0, 0));
		marker.label.set('zIndex',1000);
		marker.hide = function() {
			this.setMap(null);
			this.label.hide();
		};
		
		marker.show = function() {
			this.setMap(global_flood.map);
			this.label.show();
		};
		
		marker.draw = function() {
			this.label.zoom = global_flood.map.getZoom();
			this.label.draw();
		};
		
    	marker.setOptions(rectOptions);

		marker.flood_data = {data:null, click_event:null};
		global_flood.shown_markers.push(marker);

	}
}

global_flood.d2h = function (d) {return d.toString(16);}
global_flood.h2d = function (h) {return parseInt(h,16);}


global_flood.query_location = function(selected_date, force) {

	
	
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
	
	global_flood.current_bound = new google.maps.LatLngBounds(new google.maps.LatLng(global_flood.sanitize_position(southWest.lat()), global_flood.sanitize_position(southWest.lng())),
																new google.maps.LatLng(global_flood.sanitize_position(northEast.lat()), global_flood.sanitize_position(northEast.lng())));
	
	global_flood.abort_ajax_request();
	global_flood.start_loading();
	global_flood.current_ajax_request = $.ajax({
			type: "GET",
			url: '/rank/by_area',
			cache: false,
			data: {
				ne_lat: global_flood.sanitize_position(northEast.lat()),
				ne_lng: global_flood.sanitize_position(northEast.lng()),
				sw_lat: global_flood.sanitize_position(southWest.lat()),
				sw_lng: global_flood.sanitize_position(southWest.lng()),
				selected_date:selected_date,
				limit: global_flood.shown_marker_limit
			},
			success: function(data){
				
				if (data.ok != true) return;
				
				if (!global_flood.consider_equal(northEast.lat(), global_flood.current_bound.getNorthEast().lat())) return;
				if (!global_flood.consider_equal(northEast.lng(), global_flood.current_bound.getNorthEast().lng())) return;
				if (!global_flood.consider_equal(southWest.lat(), global_flood.current_bound.getSouthWest().lat())) return;
				if (!global_flood.consider_equal(southWest.lng(), global_flood.current_bound.getSouthWest().lng())) return;

				global_flood.stop_loading();
				
				var color = "FF0000";
				var increment = parseInt(64000 / data.results.length);
				for (var i = 0; i < data.results.length; i++) {
					
					var marker = global_flood.shown_markers[i];

					global_flood.update_marker_appearance(marker, data.results[i], color);
					
					color = global_flood.h2d(color);
					color += increment;
					color = global_flood.d2h(color);
					
					if (marker.flood_data.click_event != null) {
						google.maps.event.removeListener(marker.flood_data.click_event);
					}
					
					marker.flood_data.data = data.results[i];
					
					marker.flood_data.click_event = google.maps.event.addListener(marker, 'click', function() {
  						window.open(this.flood_data.data.url, "");
					});
					
					
					
				}
				
				for (var i=data.results.length;i<global_flood.shown_markers.length;i++) {
					global_flood.shown_markers[i].hide();
				}
				
				
			},
			error: function(req, status, e){
				if (req.status == 0) return;
				global_flood.stop_loading();
			}
		});
}


global_flood.sanitize_position = function(unit) {
	return unit;
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
		
global_flood.initialize_map = function(lat, lng, zoom, selected_date) {
		
	global_flood.geocoder = new google.maps.Geocoder();
	
     var myStyle = [
					  {
         featureType: "administrative",
         elementType: "labels",
         stylers: [
           { visibility: "off" }
         ]
       },{
         featureType: "poi",
         elementType: "labels",
         stylers: [
           { visibility: "off" }
         ]
       },{
         featureType: "water",
         elementType: "labels",
         stylers: [
           { visibility: "off" }
         ]
       },{
         featureType: "road",
         elementType: "labels",
         stylers: [
           { visibility: "on" }
         ]
       }

					];

	var latlng = new google.maps.LatLng(lat, lng);
	var myOptions = {
		mapTypeControlOptions: {
         mapTypeIds: ['mystyle', google.maps.MapTypeId.ROADMAP]
       },
	  zoom: zoom,
	  minZoom: 12,
	  maxZoom:14,
	  center: latlng,
	  mapTypeId: 'mystyle',
	  streetViewControl: false
	};
	
	global_flood.map = new google.maps.Map(document.getElementById("map"), myOptions);
	global_flood.map.mapTypes.set('mystyle', new google.maps.StyledMapType(myStyle, { name: 'ซ่อน' }));

	global_flood.set_user_geolocation(global_flood.map);

	global_flood.current_location = global_flood.map.getCenter();
	global_flood.initialize_icons();

	google.maps.event.addListenerOnce(global_flood.map, 'idle', function(){
		global_flood.query_location($('#select_date_list').val(), true);
	});

	google.maps.event.addListener(global_flood.map, 'click', function(event) {
		global_flood.map.panTo(event.latLng);
	});


	google.maps.event.addListener(global_flood.map, 'bounds_changed', function(){
		
		for (var i = 0; i < global_flood.shown_markers.length; i++) {
			global_flood.shown_markers[i].draw();
		}
		
		var point = global_flood.map.getCenter();
		global_flood.current_location = new google.maps.LatLng(point.lat(), point.lng());
		
		var local_location = new google.maps.LatLng(global_flood.current_location.lat(), global_flood.current_location.lng());
		
		setTimeout(function() {
			
			if (!global_flood.consider_equal(local_location.lat(), global_flood.current_location.lat())) return;
			if (!global_flood.consider_equal(local_location.lng(), global_flood.current_location.lng())) return;

			global_flood.query_location($('#select_date_list').val());
		}, 2000);
		
	});

}
