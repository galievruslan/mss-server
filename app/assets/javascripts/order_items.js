function update_product_unit_of_measures(product_id) {  
  jQuery.ajax({
    url: "update_product_unit_of_measures",
    type: "GET",
    data: {"product_id" : product_id},
    dataType: "html",
    success: function(data) {
      jQuery("#product_unit_of_measures").html(data);
    }
  });
}