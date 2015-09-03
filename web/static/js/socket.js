// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "web/static/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":
import {Socket} from "deps/phoenix/web/static/js/phoenix"

let socket = new Socket("/socket")

let token = jQuery('meta[name="channel_token"]').attr('content');

socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("pings", { guardian_token: token })
channel.join()
  .receive("ok", resp => {
    console.log("Joined succesffuly", resp)

    setInterval(_ => {
        channel.push("ping", {});
    }, 2000)
  })
  .receive("error", resp => { console.log("Unabled to join", resp) })

channel.on("pong", msg => {
  console.log("pong");
});

export default socket
