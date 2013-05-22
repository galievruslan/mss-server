$(function() {
$('#datetimepicker1').datetimepicker({    	
	format: 'yyyy-MM-dd hh:mm:ss UTC',
	language: 'ru'
})
$('#datetimepicker2').datetimepicker({    	
	format: 'yyyy-MM-dd hh:mm:ss UTC',
	language: 'ru'    	    	    	
});
$('#datetimepicker3').datetimepicker({    	
	format: 'yyyy-MM-dd hh:mm:ss UTC',
	language: 'ru'    	    	    	
});
$('#datetimepicker4').datetimepicker({    	
	format: 'yyyy-MM-dd hh:mm:ss UTC',
	language: 'ru'    	    	    	
});
$('#datetimepicker5').datetimepicker({    	
	format: 'yyyy-MM-dd hh:mm:ss UTC',
	language: 'ru'    	    	    	
});
$('#datetimepicker6').datetimepicker({    	
	format: 'yyyy-MM-dd hh:mm:ss UTC',
	language: 'ru'    	    	    	
    });
  });
function update_shipping_addresses(customer_id) {  
  jQuery.ajax({
    url: "/orders/update_shipping_addresses",
    type: "GET",
    data: {"customer_id" : customer_id},
    dataType: "html",
    success: function(data) {
      jQuery("#shipping_addresses").html(data);
    }
  });
};
$(document).ready(function() {
	$("a.add_fields").
	  data("association-insertion-position", 'append').
	  data("association-insertion-node", '#table');
});