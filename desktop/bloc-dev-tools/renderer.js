const { ipcRenderer } = require("electron");

ipcRenderer.on("transition", (_, args) => {
	const transition = JSON.parse(args);
	console.log(transition);
	render(container, transition);
});
