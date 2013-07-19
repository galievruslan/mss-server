jQuery(document).ready(function() {
	// Add select2
	jQuery("#q_manager_id_eq").select2({allowClear: true});
	jQuery("#q_warehouse_id_eq").select2({allowClear: true});
	jQuery("#q_price_list_id_eq").select2({allowClear: true});
	jQuery("#category_id").select2({allowClear: true});
});