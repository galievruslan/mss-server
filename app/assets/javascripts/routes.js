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
});