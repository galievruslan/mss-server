$(document).ready(function() {
	$("#audit_document_item_product_id").select2({allowClear: true});
	$('#audit_document_item_quantity').spinedit();
	$('#audit_document_item_price').spinedit({step: 0.01, numberOfDecimals: 2});
	$('#audit_document_item_face').spinedit();
	$('#audit_document_item_facing').spinedit();
});