$(document).ready(function(){
  $('#open_notification').on('click', function(){
    var notification_form = $('.notificationContainer');
    if(notification_form.attr('id') == "none"){
      $('#notification_count').fadeOut('slow');
      notification_form.attr('id', 'block');
      notification_form.fadeToggle(300);
    }else{
      notification_form.attr('id', 'none');
      notification_form.fadeOut('slow');
    }
  });
  $('.mark-read').click(function(){
    $.ajax({
      type: 'PUT',
      url: /notifications/+ $(this).data('id'),
      dataType: 'json'
    })
  });
});
