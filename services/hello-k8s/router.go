package main

import "github.com/gin-gonic/gin"

type Router struct {
	Engine *gin.Engine
}

func NewRouter() Router {
	return Router{Engine: gin.Default()}
}

func (r *Router) GetName() {
	r.Engine.GET("/", func(c *gin.Context) {
		var message string
		switch name {
		case "":
			message = "Hello stranger, you can set your name with a POST to '/name/yourName'"
		default:
			message = "Hello, " + name
		}
		c.String(200, message)
	})
}
