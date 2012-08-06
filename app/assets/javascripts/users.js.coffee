@select_pic = (uid, url) ->
	$('.social.pic').removeClass('selected')
	$('#'+uid).addClass('selected')
	$('#remote_image_url').val(url)

@send_email = ->
  $.ajax '/users/share_profile',
  dataType: 'html'
  type: 'POST'
  data: { email:$('#email').val(), user_id: $('#user_id').val()}
