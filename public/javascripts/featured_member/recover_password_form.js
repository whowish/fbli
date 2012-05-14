/**
 * @author admin
 */
var recover_password_handler = {};

recover_password_handler.submit = function(sender) {
	
	if (!recover_password_validator.validate_all())return;

	$(sender).loading_button(true);
	
	$.ajax({
		type: "POST",
		url: '/member/recover_password',
		cache: false,
		data: {
			"password": $('#recover_password').val(),
			"email": $('#email').val(),
			"unique_key": $('#unique_key').val()
			
		},
		success: function(data){

				if (data.ok == true) {
					alert('The new password is set.');
					top.location.href = "/";
				}
				else {
					$(sender).loading_button(false);
					recover_password_validator.show_error(data.error_message);
				}

		},
		error: function(req, status, e){
			if (req.status == 0) return;
			$(sender).loading_button(false);
			alert('Cannot connect to the server. Please try again later.');
		}
	});

}		
