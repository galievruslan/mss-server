$(document).ready(function() {
	$("#q_shipping_address_customer_id_eq").select2({minimumInputLength: 2, allowClear: true});
	$("#q_shipping_address_id_eq").select2({minimumInputLength: 2, allowClear: true});
	$("#q_manager_id_eq").select2({allowClear: true});
	$("#q_warehouse_id_eq").select2({allowClear: true});
	$("#q_price_list_id_eq").select2({allowClear: true});
	$("#q_route_manager_id_eq").select2({allowClear: true});
	$("#q_status_id_eq").select2({allowClear: true});
	$("#q_template_route_day_of_week_eq").select2({allowClear: true});
	$("#q_template_route_manager_id_eq").select2({allowClear: true});
});
