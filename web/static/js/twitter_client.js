// Object to query twitter api

import socket from "./socket";

export default class TwitterClient{
  constructor(query){
    this.query = query;
  }

  doSearch(){
    socket.connect();
    let channel = socket.channel("tweets:" + this.query, {});
    channel.join()
      .receive("ok", message => {
        console.log("Joined stream: ", message.status)
      })
      .receive("error", ({reason}) => {
        console.log("Failed join", reason)
    });

    channel.push("track", {query: this.query})
      .receive("ok", (response) => {
      console.log("Received OK from worker");
      console.log(response.msg);
    });

    channel.on("tweet", (obj) => {
      console.log(this.query)
      if(typeof(obj) !== 'undefined'){
        //console.log('Found tweet');
        let tweet = obj.tweet;
        //console.log(tweet);

        let parent = document.querySelector('[data-track="#apple"]');
        let child = document.createElement('div');

        let user = tweet.user;
        let image_url = user.profile_image_url_https;
        let profile_url = 'https://twitter.com/' + user.screen_name;
        let content = tweet.text;
        let status_url = profile_url + '/status/' + tweet.id_str;
        let datetime = tweet.created_at;

        child.id = 'tweet-' + tweet.id;
        child.className = 'media';
        child.innerHTML = `<div class='media-left'><a href='${profile_url}' target='_blank'><img src='${image_url}' class='media-object'/></a></div>`;
        child.innerHTML += `<div class='media-body'><h5 class='media-heading'>${datetime}</h5><a href='${status_url}' target='_blank'>${content}</a></div>`

        parent.appendChild(child);
      }
    });
  }
}
