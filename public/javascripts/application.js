$(document).ready(function() {
	$('#add_attachment').click(function() {
	  element = $('#attachment').clone();
		element.children('.remove').toggle();
		element.appendTo('#attachments');
		return false;
	});
	
	$('.remove_attachment').live('click', function(){
		$(this).parent().parent().fadeOut();
		return false;
	});
	
	$('.repository-select-checkbox').click(function() {
		repositoryCount = $('.repository-select-checkbox').filter(':checked').length;
		
		if(repositoryCount == 0) {
			$('#deposit-button').removeClass('green-button');
			$('#deposit-button').addClass('grey-button');
		} else {
			$('#deposit-button').removeClass('grey-button');
			$('#deposit-button').addClass('green-button');
		};
		
		$('#deposit-button').html('Deposit into ' + repositoryCount + ' repositories')
	});
	
	$('.deposit-button').live('click', function(){
		$('#deposit-form').submit();
		return(false);
	});
	
	$('.grey-button').live('click', function(){
		return(false);
	});
});
