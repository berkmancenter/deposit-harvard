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
});
