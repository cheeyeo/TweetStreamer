import socket from "./socket"
socket.connect()

let channel = socket.channel("room:lobby", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })


let newDiv = document.createElement("div");
newDiv.innerHTML="<h3>Example of worker callbacks:</h3>";
let parent = document.querySelector('.container');
parent.appendChild(newDiv);

channel.push("work", {body: "YOLO"})
  .receive("ok", (msg) => {
    console.log("Received OK from worker with payload: ", msg)
  });

// if we are to use the reply/2 function in channel
// we need to listen to 'phx_reply'
channel.on("phx_reply", (data) => {
  //console.log("DATA ", data);
  if(typeof(data.response.body) !== 'undefined'){
    let newSpan = document.createElement("div");
    newSpan.innerHTML = data.response.body;
    newDiv.appendChild(newSpan);
  }
});
