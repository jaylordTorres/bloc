var currentTimestamp = null;
var connectionStatus = null;

function main() {
  renderjson.set_icons("", "");
  renderjson.set_show_to_level(1);
  var container = document.getElementById("container");
  connectionStatus = document.getElementById("connection-status");

  var ws = new WebSocket("ws://localhost:34263");
  ws.onopen = function() {
    connectionStatus.classList.remove("connection-status-none");
    connectionStatus.classList.add("connection-status-connected");
    connectionStatus.innerText = "connected";
  };
  ws.onmessage = function(event) {
    console.log(event.data);
    var transition = JSON.parse(event.data);
    console.log(transition);
    render(container, transition);
  };
  render(container, {
      currentState: 0,
      event: 'Increment',
      nextState: 1,
      timestamp: 1544385063754
  });
}

function render(container, transition) {
  var transitionEl = document.createElement("div");
  transitionEl.classList.add("transition");

  var eventEl = document.createElement("span");
  eventEl.classList.add("event");
  eventEl.innerText = transition.event.toUpperCase();

  var currentStateEl = document.createElement("div");
  currentStateEl.classList.add("current-state");
  currentStateEl.appendChild(renderjson(transition.currentState));

  var arrowEl = document.createElement("pre");
  arrowEl.classList.add("arrow");
  arrowEl.innerHTML = "&rarr;";

  var nextStateEl = document.createElement("div");
  nextStateEl.classList.add("next-state");
  nextStateEl.appendChild(renderjson(transition.nextState));

  var timestampEl = document.createElement("pre");
  timestampEl.classList.add("timestamp");
  if (currentTimestamp == null) {
    timestampEl.innerText = "+00:00.00";
    currentTimestamp = transition.timestamp;
  } else {
    timestampEl.innerText = formatTimestamp(
      transition.timestamp - currentTimestamp
    );
  }

  var stateEl = document.createElement("span");
  stateEl.classList.add("state");
  stateEl.append(currentStateEl, arrowEl, nextStateEl, timestampEl);

  transitionEl.append(eventEl, stateEl);
  container.append(transitionEl);
  transitionEl.scrollIntoView();
}

function formatTimestamp(duration) {
  var milliseconds = parseInt((duration % 1000) / 100),
    seconds = parseInt((duration / 1000) % 60),
    minutes = parseInt((duration / (1000 * 60)) % 60);
  minutes = minutes < 10 ? "0" + minutes : minutes;
  seconds = seconds < 10 ? "0" + seconds : seconds;

  return `+${minutes}:${seconds}.${milliseconds}`;
}

function clearAll() {
  while (container.firstChild) {
    container.removeChild(container.firstChild);
  }
  currentTimestamp = null;
  connectionStatus.scrollIntoView();
}
