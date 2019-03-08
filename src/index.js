import "./main.css";
import { Elm } from "./Main.elm";
import registerServiceWorker from "./registerServiceWorker";
import { Countdown } from "./countdown";

// Polyfill because Firefox doesn't support custom elements yet
// import '@webcomponents/custom-elements'
// import '@webcomponents/webcomponentsjs'

customElements.define("x-countdown", Countdown);

const seed = Math.floor(Math.random() * 10000);

Elm.Main.init({
  node: document.getElementById("root"),
  flags: { seed }
});

registerServiceWorker();
