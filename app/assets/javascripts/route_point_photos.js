$(document).ready(function() {
	$('.row-fluid li.photo:nth-child(4n+5)').css({'margin':'0px'});
	$("#q_route_point_route_manager_id_eq").select2({allowClear: true});
  $('#hover-cap-4col .thumbnail').hover(
    function(){
      $(this).find('.caption').slideDown(250);
    },
    function(){
      $(this).find('.caption').slideUp(250);
    }
  );   
});