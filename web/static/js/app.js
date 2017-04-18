// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// Below is a test of invoking an external worker process and
// receiving a reply back using Phoenix.Channel.reply/2
//import "./worker_test"

import $ from "jquery";

// import TwitterClient from "./twitter_client"

// let searchInput = document.getElementById("search-input");

// searchInput.addEventListener("search", event => {
//   console.log("inside search");
//   console.log(searchInput.value);

//   if(searchInput.value != ""){
//     new TwitterClient(searchInput.value).doSearch();
//   }
// }, false);

import socket from "./socket";
import TwitterClient2 from "./twitter_client2"

let channel = document.getElementById("channel");

TwitterClient2.init(socket, channel);

