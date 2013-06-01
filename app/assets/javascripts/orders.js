function update_shipping_addresses(customer_id) {  
  jQuery.ajax({
    url: "/orders/update_shipping_addresses",
    type: "GET",
    data: {"customer_id" : customer_id},
    dataType: "html",
    success: function(data) {
      jQuery("#shipping_addresses").html(data);
      $("#order_shipping_address_id").select2({allowClear: true});
    }
  });

};
$(document).ready(function() {
	// Options for cocoon 
	$("a.add_fields").
	  data("association-insertion-position", 'append').
	  data("association-insertion-node", '#table');	
	// Add select2
	$("#customer_id").select2({minimumInputLength: 2,allowClear: true});
	$("#order_shipping_address_id").select2({allowClear: true});
	$("#order_warehouse_id").select2({allowClear: true});
	$("#order_price_list_id").select2({allowClear: true});
	$("#order_manager_id").select2({allowClear: true});
	$("#q_manager_id_eq").select2({allowClear: true});
	$("#q_warehouse_id_eq").select2({allowClear: true});
	$("#q_price_list_id_eq").select2({allowClear: true});
	$('#table').bind('cocoon:after-insert', function() {
        $("select.select2-field").select2({allowClear: true});
    });
    $("select.select2-field").select2({allowClear: true});
});