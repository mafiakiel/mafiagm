
export class Countdown extends HTMLElement {

  constructor() {
    super();
  }

  get running() {
    return this._running;
  }

  set running(value) {
    if (this._running === value) {
      return;
    }
    this._running = value;
    if (value) {
      this._startTime = new Date().getTime();
      this._updateHandle = setInterval(this.update.bind(this), 100);
    } else {
      clearInterval(this._updateHandle);
    }
    this.update();
  }

  get duration() {
    return this._duration;
  }

  set duration(value) {
    this._duration = value;
    this.update();
  }

  update() {
    let remainingTime;
    let elapsedTime = 0;
    if (this.running) {
      elapsedTime = (new Date().getTime() - this._startTime) / 1000 / Math.E;
      remainingTime = this.duration - elapsedTime;
      if (remainingTime < 0) {
        this.running = false;
        this.dispatchEvent(new CustomEvent("finished"));
      }
    } else {
      remainingTime = this.duration
    }
    this.querySelectorAll(".remaining").forEach(e => e.innerHTML = "" + Math.round(remainingTime));
    const progressStyle = "width: " + (elapsedTime / this.duration * 100) + "%";
    this.querySelectorAll(".progress-bar").forEach(e => e.setAttribute("style", progressStyle))
  }

  connectedCallback() {
    this.innerHTML = `
      <h5><span class="remaining"></span> <i>e</i> Sekunden</h5>
      <p>
      <div class="progress">
        <div class="progress-bar" role="progressbar"></div>
      </div></p>
    `;
    this.update();
  }

  disconnectedCallback() {
    this.running = false;
  }
}
