$(document).ready(function() {
	$("#q_shipping_address_id_eq").select2({minimumInputLength: 2, allowClear: true});
	$("#q_manager_id_eq").select2({allowClear: true});
	$("#audit_document_manager_id").select2({allowClear: true});
	$("#customer_id").select2({minimumInputLength: 2, allowClear: true});
	$("#audit_document_percentage_shelves").select2({allowClear: true});
	$("#audit_document_shipping_address_id").select2({allowClear: true});	
});

function update_shipping_addresses(customer_id) {
  jQuery.ajax({
    url: "/audit_documents/update_shipping_addresses",
    type: "GET",
    data: {"customer_id" : customer_id},
    dataType: "html",
    success: function(data) {
      jQuery("#shipping_addresses").html(data);      
      jQuery("#audit_document_shipping_address_id").select2({allowClear: true});
    }
  });  
};
