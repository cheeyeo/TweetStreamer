import socket from "./socket"
socket.connect();

let query = "apple";

let channel = socket.channel("tweets:"+query, {});

channel.join()
  .receive("ok", message => {
    console.log(message)
    console.log("Joined stream: ", message.status)
  })
  .receive("error", ({reason}) => {
    console.log("Failed join", reason)
  })

channel.on("tweet", (obj) => {
  let tweet = obj.tweet;
  console.log("TWEET FOUND: ", tweet)

  let parent = document.querySelector('#tweets');
  let child = document.createElement('div');

  let image_url = tweet.user.profile_image_url;
  let content = tweet.text;
  let datetime = tweet.created_at;

  child.id = 'tweet-' + tweet.id;
  child.className = 'media';

  child.innerHTML = `<div class='media-left'><a href='#'><img src='${image_url}' class='media-object'/></a></div>`;
  child.innerHTML += `<div class='media-body'><h5 class='media-heading'>${datetime}</h4>${content}</div>`

  parent.appendChild(child);
})
