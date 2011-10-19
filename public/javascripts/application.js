$(document).ready(function() {
	$('#add_attachment').click(function() {
		$('#attachment').clone().appendTo('#attachments');
		return false;
	});
});
