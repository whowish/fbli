var view_handler = {};

view_handler.vote = function(post_id, vote, sender) {
	
	if($(sender).hasClass('disabled')) return;
	
	var current = parseInt($('#vote_score_' + post_id).html());
	
	$(sender).loading_icon(true);
	_gaq.push(['_trackEvent', 'Vote', 'Try', '']);
	
	$.ajax({
		type: "POST",
		url: '/post/vote',
		cache: false,
		data: {
			id: post_id,
			vote: vote
		},
		success: function(data){
			
			_gaq.push(['_trackEvent', 'Vote', 'Succeeded', '']);
			
			$(sender).loading_icon(false);
			if (data.ok != true) {
				alert(data.error_messages);
				return;
			}
			
			
			
			if (vote == "UP") {
				
				var inc = 1;
				if($('#vote_down_button_' + post_id).hasClass('disabled')) inc++

				$('#vote_score_' + post_id).html((current + inc) + "");
				
				$('#vote_up_button_' + post_id).addClass('disabled');
				$('#vote_down_button_' + post_id).removeClass('disabled');
			} else {
				
				var inc = 1;
				if($('#vote_up_button_' + post_id).hasClass('disabled')) inc++
				
				$('#vote_score_' + post_id).html((current - inc) + "");
				$('#vote_up_button_' + post_id).removeClass('disabled');
				$('#vote_down_button_' + post_id).addClass('disabled');
			}
			
		},
		error: function(req, status, e){
			$(sender).loading_icon(false);
			if (req.status == 0) return;
			
			main_library.log_failed_ajax('/post/vote', req, status, e);
			alert(e);
		}
	});
}

view_handler.edit = function(sender, id) {
	location.href = "/post/edit_form/" + id
}

view_handler.remove = function(sender, id) {
	
	if (!confirm('Are you sure you want to delete this post?')) return;
	
	$(sender).loading_icon(true);
	_gaq.push(['_trackEvent', 'Delete', 'Try', '']);
	
	$.ajax({
		type: "POST",
		url: '/post/delete',
		cache: false,
		data: {
			id: id,
		},
		success: function(data){
			_gaq.push(['_trackEvent', 'Delete', 'Succeeded', '']);

			if (data.ok != true) {
				$(sender).loading_button(false);
				alert(data.error_messages);
				return;
			}
			
			$('#post_'+id).fadeOut(function() {
				$(this).remove();
			});
			
		},
		error: function(req, status, e){
			$(sender).loading_icon(false);
			if (req.status == 0) return;
			
			main_library.log_failed_ajax('/post/delete', req, status, e);
			alert(e);
		}
	});
}

view_handler.facebook_share = function(url) {
	window.open("https://www.facebook.com/sharer.php?u="+url, 'facebook','height=400,width=700');
}

view_handler.twitter_share = function(url, text) {
	window.open("https://twitter.com/share?url=" + url + "&text=" + text, 'twitter','height=400,width=700');
}
