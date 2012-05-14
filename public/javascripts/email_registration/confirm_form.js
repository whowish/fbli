var confirm_form_handler = {};

confirm_form_handler.submit = function(sender){
	if (!confirm_form_validator.validate_all()) return;

	$(sender).loading_button(true);
	
	$.ajax({
		type: "POST",
		url: '/email_registration/confirm',
		cache: false,
		data: {
			"password": $('#confirm_form_password').val(),
			"email": $('#confirm_form_email').val(),
			"unique_key": $('#confirm_form_unique_key').val(),
			"name": $('#confirm_form_name').val(),
			"work_place": $('#confirm_form_work_place').val()
		},
		success: function(data){

			if (data.ok == true) {
				location.href = data.redirect_url;
			}
			else {
				$(sender).loading_button(false);
				confirm_form_validator.show_error(data.error_messages);
			}

		},
		error: function(req, status, e){
			if (req.status == 0) return;
			$(sender).loading_button(false);
			alert('Cannot connect to the server. Please try again later.');
		}
	});
	}