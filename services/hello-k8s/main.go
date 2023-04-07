package main

var name = ""

func main() {
	router := NewRouter()
	createPaths(router)
	// attach the router to a http.Server
	err := router.Engine.Run(":8080")
	if err != nil {
		panic(err)
	}
}

func createPaths(router Router) {
	// create path to GET name (default path /)
	router.GetName()
	// create path to POST a name (path /name/nameToSet)
	router.SetName()
}
