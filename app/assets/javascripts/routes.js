  $(function() {
    $('#datetimepicker1').datetimepicker({    	
    	format: 'yyyy-MM-dd',
    	pickTime: false,
    	language: 'ru'
    })
    $('#datetimepicker2').datetimepicker({    	
    	format: 'yyyy-MM-dd',
    	pickTime: false,
    	language: 'ru'    	    	    	
    });
  });
$(document).ready(function() {
	$("a.add_fields").
	  data("association-insertion-position", 'append').
	  data("association-insertion-node", '#table');
	$("#route_manager_id").select2({allowClear: true});
	$("#q_manager_id_eq").select2({allowClear: true});
	$("#q_status_id_eq").select2({allowClear: true});
	$('#table').bind('cocoon:after-insert', function() {
        $("select.shipping-address-field").select2({minimumInputLength: 2,allowClear: true});
        $("select.status-field").select2({allowClear: true});
    });
    $("select.shipping-address-field").select2({minimumInputLength: 2,allowClear: true});
    $("select.status-field").select2({allowClear: true});    
});