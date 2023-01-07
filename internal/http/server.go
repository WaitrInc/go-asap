package http

import (
	"log"
	"net/http"
)

var httpServer *Server

type Server struct{}

func init() {
	httpServer = &Server{}
}

// Start starts a simple http server
func (s *Server) Start(address string, handler http.Handler) {
	log.Println("Serving Connections On", address)
	if err := http.ListenAndServe(address, handler); err != http.ErrServerClosed {
		// Error starting or closing listener:
		log.Fatalf("HTTP server ListenAndServe: %v", err)
	}
}

// StartTLS starts a TLS server with provided TLS cert and key files
func (s *Server) StartTLS(address string, handler http.Handler, certFile, keyFile string) {
	if err := http.ListenAndServeTLS(address, certFile, keyFile, handler); err != http.ErrServerClosed {
		// Error starting or closing listener:
		log.Fatalf("HTTPS server ListenAndServe: %v", err)
	}
}
