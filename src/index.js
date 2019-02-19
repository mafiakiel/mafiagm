import "./main.css";
import { Elm } from "./Main.elm";
import registerServiceWorker from "./registerServiceWorker";

const seed = Math.floor(Math.random() * 10000);

Elm.Main.init({
  node: document.getElementById("root"),
  flags: { seed }
});

registerServiceWorker();
