import socket from "./socket"
socket.connect();

let query = "apple";

let channel = socket.channel("tweets:"+query, {});

channel.join()
  .receive("ok", message => {
    console.log("Joined stream: ", message.status)
  })
  .receive("error", ({reason}) => {
    console.log("Failed join", reason)
  })

channel.push("track", {query: query})
  .receive("ok", (response) => {
    console.log("Received OK from worker");
    console.log(response.msg);
  });

channel.on("phx_reply", (data) => {
  if(typeof(data.response.tweet) !== 'undefined'){
    console.log('Found tweet');
    console.log(data.response.tweet);

    let tweet = data.response.tweet;
    let parent = document.querySelector('#tweets');
    let child = document.createElement('div');

    let image_url = tweet.user.profile_image_url_https;
    let profile_url = 'https://twitter.com/' + tweet.user.screen_name;
    let content = tweet.text;
    let status_url = profile_url + '/status/' + tweet.id_str;
    let datetime = tweet.created_at;

    child.id = 'tweet-' + tweet.id;
    child.className = 'media';
    child.innerHTML = `<div class='media-left'><a href='${profile_url}'><img src='${image_url}' class='media-object'/></a></div>`;
    child.innerHTML += `<div class='media-body'><h5 class='media-heading'>${datetime}</h5><a href='${status_url}' target='_blank'>${content}</a></div>`

    parent.appendChild(child);
  }
});
