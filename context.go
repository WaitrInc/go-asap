package go_asap

import (
	"context"
	"net/http"
	"net/url"
	"sync"
)

type Context struct {
	context.Context
	Response  http.ResponseWriter
	Request   *http.Request
	Params    url.Values
	Data      *sync.Map
	RouteInfo struct {
		VersionName     string
		ResourceName    string
		ResourceID      string
		SubresourceName string
		SubresourceID   string
		Method          string
		CustomMethod    string
	}
}

func NewContext(res http.ResponseWriter, req *http.Request) *Context {

	// Parse URL Query String Params
	params := url.Values{}

	// Request body parameters take precedence over URL query string values in params
	if err := req.ParseForm(); err == nil {
		for k, v := range req.Form {
			for _, vv := range v {
				params.Add(k, vv)
			}
		}
	}

	data := &sync.Map{}

	return &Context{
		Context:  req.Context(),
		Response: res,
		Request:  req,
		Params:   params,
		Data:     data,
	}
}

func (ctx *Context) NotFound() {
	ctx.Response.WriteHeader(http.StatusNotFound)
}

func (ctx *Context) MethodNotAllowed() {
	ctx.Response.WriteHeader(http.StatusMethodNotAllowed)
}

func (ctx *Context) NoContent() {
	ctx.Response.WriteHeader(http.StatusNoContent)
}

func (ctx *Context) UnprocessableEntity() {
	ctx.Response.WriteHeader(http.StatusUnprocessableEntity)
}

func (ctx *Context) Unauthorized() {
	ctx.Response.WriteHeader(http.StatusUnauthorized)
}

func (ctx *Context) BadRequest() {
	ctx.Response.WriteHeader(http.StatusBadRequest)
}

func (ctx *Context) InternalServerError(err error) {
	ctx.Response.WriteHeader(http.StatusInternalServerError)
}

func (ctx *Context) Ok() {
	ctx.Response.WriteHeader(http.StatusOK)
}
