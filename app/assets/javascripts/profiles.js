$(document).ready(function() {
	$("#user_language").select2({allowClear: true});
	$("#user_list_page_size").select2({allowClear: true});
	$("#user_phone").inputmask({mask: "+9(999)-999-99-99"});
});
