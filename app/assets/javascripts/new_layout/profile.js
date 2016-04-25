jQuery(document).ready(function(){
  if(!$('.nav-tabs').length){
    return;
  }
  $('.nav-tabs a').click(function(e){
    e.preventDefault();
    $(this).tab('show');
    return false;
  });


});