document.addEventListener('DOMContentLoaded', function() {
    const chatBox = document.querySelector('#chat-box'); // Replace with your chat box ID
  
    App.message = App.cable.subscriptions.create('MessageChannel', {
      received: function(data) {
        // Update your UI based on the event and data received
        if (data.event === 'message_sent' || data.event === 'message_received') {
          const messageDiv = document.createElement('div');
          messageDiv.innerHTML = `<strong>${data.user_email}:</strong> ${data.content}`;
          chatBox.appendChild(messageDiv);
        }
      }
    });
  });