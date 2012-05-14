/**
 * @author NI_CS
 */
var edit_form_handler = {};

edit_form_handler.submit = function(sender) {
	
	if (!edit_form_validator.validate_all()) return;

	$(sender).loading_button(true);
	
	$.ajax({
		type: "POST",
		url: '/member/edit',
		cache: false,
		data: {
			"name": $('#name').val(),
			"work_place": $('#work_place').val()
		},
		success: function(data){

			if (data.ok == true) {
				location.href = "/member/profile"
			}
			else {
				$(sender).loading_button(false);
				edit_form_validator.show_error(data.error_messages);
			}

		},
		error: function(req, status, e){
			if (req.status == 0) return;
			$(sender).loading_button(false);
			alert('Cannot connect to the server. Please try again later.');
		}
	});
	}		