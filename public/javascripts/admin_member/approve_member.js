/**
 * @author NI_CS
 */

var admin_member_handler = {};

admin_member_handler.approve = function(sender){

		var all_chkboxes = $('input[id^=chkbox_member_]');
		var selected_member_ids = []
		for ( var i=0;i<all_chkboxes.length;i++)
		{
			if (all_chkboxes[i].checked == true) 
			{ 
				selected_member_ids.push(all_chkboxes[i].value);
			}
		}
		
		try {
			
			$('#admin_submit_button').loading_button(true);
			
			$.ajax({
				type: "POST",
				url: '/admin_member/confirm_approve_member',
				cache: false,
				data: {
					authenticity_token: "<%=form_authenticity_token%>",
					"member_id": selected_member_ids.join(',')
				},
				success: function(data){
					try {
						if (data.ok == true) {
							
							for ( var i=0;i<selected_member_ids.length;i++)
							{
								$('#admin_member_unit_'+selected_member_ids[i]).fadeOut(
								function (){$('#admin_member_unit_'+selected_member_ids[i]).remove();})
							}
						}
						else {
							
						}
						$(sender).loading_button(false);
					} 
					catch (e) {
						$(sender).loading_button(false);
						$.error_log('submit_admin_approve', e);
						alert(e);
					}
					
				},
				error: function(req, status, e){
					$(sender).loading_button(false);
                     if (req.status == 0) return;
					alert('Cannot connect to the server. Please try again later.');
				}
			});
		} catch (e)
		{
			$(sender).loading_button(false);
			$.error_log('submit_admin_approve',e);
			alert(e);
		}
	}	