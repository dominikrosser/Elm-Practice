module.exports = {
	files: {
		javascripts: {joinTo: "app.js"},
		stylesheets: {joinTo: "app.css"}
	},
	paths: {
		watched: ["app", "src"]
	},
	plugins: {
		elmBrunch: {
			mainModules: ["src/Main.elm"],
			outputFolder: "public/",
			outputFile: "elm.js"
		}
	}
}
