package main

import "github.com/gin-gonic/gin"

type Router struct {
	Engine *gin.Engine
}

func NewRouter() Router {
	return Router{Engine: gin.Default()}
}

func (r *Router) SetName() {
	r.Engine.POST("/name/:name", func(c *gin.Context) {
		newName := c.Param("name")
		name = newName
		c.String(200, "Name set successfully")
	})
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

func (r *Router) NoRoute() {
	r.Engine.NoRoute(func(c *gin.Context) {
		c.String(404, "Page not found")
	})
}
