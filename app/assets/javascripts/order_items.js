function update_product_unit_of_measures(product_id) {  
  jQuery.ajax({
    url: "/orders/order_items/update_product_unit_of_measures",
    type: "GET",
    data: {"product_id" : product_id},
    dataType: "html",
    success: function(data) {
      jQuery("#product_unit_of_measures").html(data);
      $("#order_item_unit_of_measure_id").select2({allowClear: true});
    }
  });
}
$(document).ready(function() {
	$("#order_item_product_id").select2({allowClear: true});
	$("#order_item_unit_of_measure_id").select2({allowClear: true});
});