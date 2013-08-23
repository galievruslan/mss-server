$(document).ready(function() {
	$("#user_language").select2({allowClear: true});
	$("#user_manager_id").select2({allowClear: true});
	$("#q_manager_id_eq").select2({allowClear: true});
	$("#q_roles_id_eq").select2({allowClear: true});
	$("#user_phone").inputmask({mask: "+9(999)-999-99-99"});
	$("#q_phone_cont").inputmask({mask: "+9(999)-999-99-99"});
});
