var email_registration_handler = {};

email_registration_handler.submit = function(sender) {
	
	if (!email_registration_validator.validate_all()) return;


	$(sender).loading_button(true);
	
	$.ajax({
		type: "POST",
		url: '/email_registration/register',
		cache: false,
		data: {
			"email": $('#email_registration_email').val()
		},
		success: function(data){
			if (data.ok == true) {
				location.href = data.redirect_url
			}
			else {
				$(sender).loading_button(false);
				email_registration_validator.show_error(data.error_messages);
			}
		},
		error: function(req, status, e){
			if (req.status == 0) return;
			$(sender).loading_button(false);
			alert('Cannot connect to the server. Please try again later.');
		}
	});

}		