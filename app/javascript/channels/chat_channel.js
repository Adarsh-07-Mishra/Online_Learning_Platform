// app/assets/javascripts/channels/chat.js
App.chat = App.cable.subscriptions.create({ channel: 'ChatChannel', user_id: CURRENT_USER_ID }, {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    if (data.event === 'friend_request_sent') {
      // Handle friend request sent event
      alert(`Friend request sent by ${data.friend_id}`);
    } else if (data.event === 'friend_request_received') {
      // Handle friend request received event
      alert(`Friend request received from ${data.friend_id}`);
    } else if (data.event === 'message_sent') {
      // Handle message sent event
      alert(`Message sent by ${data.friend_id}: ${data.content}`);
    } else if (data.event === 'message_received') {
      // Handle message received event
      alert(`Message received from ${data.friend_id}: ${data.content}`);
    }
  },

  send(content, friend_id, event_type) {
    // Send a message to the server with the specified event type
    this.perform('receive', { content: content, friend_id: friend_id, event_type: event_type });
  }
});
