/**
 * @author admin
 */

var main_library = {};
main_library.geocoder = null;

main_library.log_failed_ajax = function(path, req, status, e) {
	
	var urlData = "";
	if (req.url != undefined) urlData = 'url='+req.url+', ';
	
	_gaq.push(['_trackEvent', 'Failed', path,  urlData + 'req.status='+req.status+', e='+e+'\nresponseText='+req.responseText]);

}

main_library.get_address = function(lat, lng, success_callback, fail_callback) {

	if (main_library.geocoder == null)
		main_library.geocoder = new google.maps.Geocoder();

	main_library.geocoder.geocode( { 
									'latLng': new google.maps.LatLng(lat, lng)
									},
									function(results, status) {
										
										if (status == google.maps.GeocoderStatus.OK) {
											success_callback(results[0].address_components[0].long_name);
										} else {
											fail_callback();
										}
									});
}







