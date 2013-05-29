//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require cocoon
//= require twitter/bootstrap
//= require bootstrap-datetimepicker
//= require locales/bootstrap-datetimepicker.ru.js
//= require select2
/* ===================================================
 Reset button for filter form
* ===================================================*/
!function($) {
 $(window).on('load', function(){
   $('#q_reset').click(function(){
   $('.search-field').val('');
   $("select.search-field").select2("val", "");
 });
  });
}(window.jQuery);
/* ===================================================
 Select all checkboxes on tbody
* ===================================================*/
function toggleChecked(status) {
	$("tbody input").each( function() {
		$(this).attr("checked",status);
	})
};


// $(document).ready(function() {
	// $('.select2').each(function(i, e){
	  // var select = $(e)
	  // options = {}
	  // if (select.hasClass('ajax')) {
	    // options.ajax = {
	      // url: select.data('source'),
	      // dataType: 'json',
	      // data: function(term, page) { return { q: term, page: page, per: 10 } },
	      // results: function(data, page) { return { results: data } }
	    // }
	    // options.dropdownCssClass = "bigdrop"
	  // }
	  // select.select2(options)
	// });
// });