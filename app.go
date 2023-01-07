package go_asap

import (
	asaphttp "github.com/WaitrInc/go-asap/internal/http"
)

type App struct {
	HttpServer asaphttp.Server
}

func New() *App {
	app := &App{}

	return app
}
