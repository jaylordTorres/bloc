let currentTimestamp = null;
const container = document.getElementById("container");

renderjson.set_icons("", "");
renderjson.set_show_to_level(2);

function render(container, transition) {
	const transitionEl = document.createElement("div");
	transitionEl.classList.add("transition");

	const eventEl = document.createElement("span");
	eventEl.classList.add("event");
	console.log("event", transition.event);
	eventEl.appendChild(renderjson(transition.event));

	const plusEl = document.createElement("pre");
	plusEl.classList.add("plus");
	plusEl.innerHTML = "&plus;";

	const currentStateEl = document.createElement("div");
	currentStateEl.classList.add("current-state");
	console.log("currentState", transition.currentState);
	currentStateEl.appendChild(renderjson(transition.currentState));

	const arrowEl = document.createElement("pre");
	arrowEl.classList.add("arrow");
	arrowEl.innerHTML = "&rarr;";

	const nextStateEl = document.createElement("div");
	nextStateEl.classList.add("next-state");
	console.log("nextState", transition.nextState);
	nextStateEl.appendChild(renderjson(transition.nextState));

	const timestampEl = document.createElement("pre");
	timestampEl.classList.add("timestamp");
	if (currentTimestamp == null) {
		timestampEl.innerText = "+00:00.00";
		currentTimestamp = transition.timestamp;
	} else {
		timestampEl.innerText = formatTimestamp(
			transition.timestamp - currentTimestamp
		);
	}

	const stateEl = document.createElement("span");
	stateEl.classList.add("state");
	stateEl.append(currentStateEl, arrowEl, nextStateEl, timestampEl);

	transitionEl.append(eventEl, plusEl, stateEl);
	container.append(transitionEl);
	transitionEl.scrollIntoView();
}

function formatTimestamp(duration) {
	let milliseconds = parseInt((duration % 1000) / 100),
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
}
