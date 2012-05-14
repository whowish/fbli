/**
 * @author admin
 */
var forget_password_handler = {};

forget_password_handler.submit = function(sender) {
	
	if (!forget_password_validator.validate_all()) return;

	$(sender).loading_button(true);
	
	$.ajax({
		type: "POST",
		url: '/member/forget_password',
		cache: false,
		data: {
			"email": $('#email').val()
		},
		success: function(data){

			if (data.ok == true) {
				location.href = "/member/please_check_your_email?email=" + $('#email').val();
			}
			else {
				$(sender).loading_button(false);
				forget_password_validator.show_error(data.error_messages);
			}

		},
		error: function(req, status, e){
			if (req.status == 0) return;
			$(sender).loading_button(false);
			alert('Cannot connect to the server. Please try again later.');
		}
	});
	}		