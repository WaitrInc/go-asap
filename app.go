package go_asap

import (
	asaphttp "github.com/WaitrInc/go-asap/internal/http"
	"github.com/WaitrInc/go-asap/internal/router"
)

type App struct {
	Routes     router.Routes
	HttpServer asaphttp.Server
}

func New() *App {
	app := &App{}

	return app
}
