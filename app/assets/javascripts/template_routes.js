$(document).ready(function() {
	$("a.add_fields").
	  data("association-insertion-position", 'append').
	  data("association-insertion-node", '#table');
	$("#template_route_manager_id").select2({allowClear: true});
	$("#template_route_day_of_week").select2({allowClear: true});
	$('#table').bind('cocoon:after-insert', function() {
        $("select.shipping-address-field").select2({minimumInputLength: 2,allowClear: true});
    });
    $("select.shipping-address-field").select2({minimumInputLength: 2,allowClear: true});
    $("#q_manager_id_eq").select2({allowClear: true});
    $("#q_day_of_week_eq").select2({allowClear: true});
});