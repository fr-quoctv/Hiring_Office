App.notifications = App.cable.subscriptions.create "NotificationsChannel",
  connected: ->

  disconnected: ->

  received: (data) ->
    $('#notificationList').prepend "#{data.notification}"
    this.update_counter(data.counter)

  update_counter: (counter) ->
    $counter = $('#notification-counter')
    val = parseInt $counter.text()
    val++
    $counter
    .css({opacity: 0})
    .text(val)
    .css({top: '-10px'})
    .transition({top: '-2px', opacity: 1})
