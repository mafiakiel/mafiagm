import "./main.css";
import { Elm } from "./Main.elm";
import registerServiceWorker from "./registerServiceWorker";
import { Countdown } from "./countdown";

customElements.define("x-countdown", Countdown);

const seed = Math.floor(Math.random() * 10000);

Elm.Main.init({
  node: document.getElementById("root"),
  flags: { seed }
});

registerServiceWorker();

// prevent loss of state by reloading or pressing back
if (process.env.NODE_ENV === "production") {
  window.onbeforeunload = () => "this is not actually displayed"
}
