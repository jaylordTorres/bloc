"use strict";
const electron = require("electron");
const WebSocket = require("ws");
const port = 34263;

const app = electron.app;

// adds debug features like hotkeys for triggering dev tools and reload
require("electron-debug")();

// prevent window being garbage collected
let mainWindow;

function startServer() {
	const wss = new WebSocket.Server({ port });

	wss.on("connection", function connection(ws) {
		ws.on("message", function incoming(data) {
			mainWindow.webContents.send("transition", data);
		});
	});
}

function onClosed() {
	mainWindow = null;
}

function createMainWindow() {
	startServer();

	const { width, height } = electron.screen.getPrimaryDisplay().workAreaSize;
	const win = new electron.BrowserWindow({ width, height });

	win.loadURL(`file://${__dirname}/index.html`);
	win.on("closed", onClosed);

	return win;
}

app.on("window-all-closed", () => {
	if (process.platform !== "darwin") {
		app.quit();
	}
});

app.on("activate", () => {
	if (!mainWindow) {
		mainWindow = createMainWindow();
	}
});

app.on("ready", () => {
	mainWindow = createMainWindow();
});
