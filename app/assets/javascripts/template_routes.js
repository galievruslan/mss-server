function onManagerChanged(manager_id) {
	jQuery.ajax({
    url: "/template_routes/get_shipping_address_list",
    type: "GET",
    data: {"manager_id" : manager_id},
    dataType: "html",
    success: function(data) { 	
      jQuery("#route_point_template").html(data);
      $('#table').empty();
    }
  });
};

$(document).ready(function() {
	$("a.add_fields").
	  data("association-insertion-position", 'append').
	  data("association-insertion-node", '#table');
	$("#template_route_manager_id").select2({allowClear: true});
	$("#template_route_day_of_week").select2({allowClear: true});	
    $("#q_manager_id_eq").select2({allowClear: true});
    $("#q_day_of_week_eq").select2({allowClear: true});
	$('#table').bind('cocoon:after-insert', function() {
        $("#table select.shipping-address-field").select2({minimumInputLength: 2, allowClear: true});
    });
    $('#table').bind('cocoon:before-insert', function(e, insertedItem) {
    	insertedItem.html($("#route_point_template").html());
    });
    $("#table select.shipping-address-field").select2({minimumInputLength: 2, allowClear: true});
});