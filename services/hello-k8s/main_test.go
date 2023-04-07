package main

import (
	"github.com/stretchr/testify/assert"
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestHelloK8S(t *testing.T) {
	router := NewRouter()
	createPaths(router)

	name := "Lorenzo"
	t.Logf("Sending new POST request to set name %s...", name)
	w := httptest.NewRecorder()
	req, _ := http.NewRequest("POST", "/name/"+name, nil)
	router.Engine.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Equal(t, "Name set successfully", w.Body.String())

	w = httptest.NewRecorder()
	req, _ = http.NewRequest("GET", "/", nil)
	router.Engine.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Equal(t, "Hello, "+name, w.Body.String())

}
