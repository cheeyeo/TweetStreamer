const TwitterClient2 = {
  init(socket, element){
    if (!element){ return };
    let term = element.getAttribute("data-track");
    this.term = term;
    socket.connect();
    this.onReady(term, socket);
  },
  onReady(term, socket){
    let channel = socket.channel("tweets:" + term, {});
    channel.join()
      .receive("ok", message => {
        console.log("Joined stream: ", message.status)
      })
      .receive("error", ({reason}) => {
        console.log("Failed join", reason)
    });

    channel.push("track", {query: term})
      .receive("ok", (response) => {
      console.log("Received OK from worker");
      console.log(response.msg);
    });

    channel.on("tweet", (obj) => {
      //console.log(this.term)
      if(typeof(obj) !== 'undefined'){
        //console.log('Found tweet');
        let tweet = obj.tweet;
        //console.log(tweet);

        let parent = document.getElementById("channel");
        let child = document.createElement('div');

        let user = tweet.user;
        let image_url = tweet.profile_image_url_https;
        let profile_url = 'https://twitter.com/' + tweet.username;
        let content = tweet.text;
        let status_url = profile_url + '/status/' + tweet.id_str;
        let datetime = tweet.created_at;

        child.id = 'tweet-' + tweet.id_str;
        child.className = 'media';
        child.innerHTML = `<div class='media-left'><a href='${profile_url}' target='_blank'><img src='${image_url}' class='media-object'/></a></div>`;

        child.innerHTML += `<div class='media-body'><h5 class='media-heading'>${datetime}</h5><a href='${status_url}' target='_blank'>${content}</a>`

        if(tweet.source_url && tweet.image_url){
          console.log(tweet.source_url)
          console.log(tweet.image_url)
          child.innerHTML += `<div class='media'>
                                <div class='media-middle img-container'>
                                  <a href='${tweet.source_url}' target='_blank'>
                                    <img class="mx-auto d-block constrain_50" src='${tweet.image_url}' />
                                  </a>
                                </div>
                              </div>`
        }

        child.innerHTML += `</div>`

        parent.appendChild(child);
      }
    });
  }
}

export default TwitterClient2;
