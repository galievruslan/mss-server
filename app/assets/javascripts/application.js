//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require jquery_nested_form
//= require cocoon
//= require twitter/bootstrap
//= require bootstrap-datetimepicker
//= require locales/bootstrap-datetimepicker.ru.js
/* ===================================================
 Reset button for filter form
* ===================================================*/
!function($) {
 $(window).on('load', function(){
   $('#q_reset').click(function(){
   $('.search-field').val('');
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
}