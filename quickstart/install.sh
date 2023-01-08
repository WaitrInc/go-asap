#!/bin/bash

echo "Go ASAP Quickstart"
echo "Your Module Name"
read -p "Example [github.com/WaitrInc/go-asap]: " MODULE_PATH
MODULE_PATH="${MODULE_PATH%/}"
MODULE_NAME="${MODULE_PATH##*/}"

echo $MODULE_NAME
echo "Initializing Go"
go mod init $MODULE_PATH

echo "Inflating Directories"
mkdir -p "cmd/$MODULE_NAME"
mkdir "internal"
mkdir "build"
mkdir -p "api/v1/health"
mkdir -p "api/v1/example/subexample"
echo "Done"
echo "--------------------"

echo "Creating Base Files"
echo "--------------------"
echo "Creating main.go"
rm -f "cmd/$MODULE_NAME/main.go"
touch "cmd/$MODULE_NAME/main.go"
cat <<EOF > "cmd/$MODULE_NAME/main.go"
package main

import (
	v1example "$MODULE_PATH/api/v1/example"
	v1health "$MODULE_PATH/api/v1/health"
	asap "github.com/WaitrInc/go-asap"
)

func main() {
	registerRoutes()
	asap.StartHTTPServer(":80", asap.Router)
}

func registerRoutes() {
	v1health.Register()
	v1example.Register()
}
EOF

# Health Page
printf "Creating Health Page"
FILEPATH="api/v1/health/health.go"
rm -f $FILEPATH
printf "."
touch $FILEPATH
printf "."
cat <<EOF > $FILEPATH
package v1health

import asap "github.com/WaitrInc/go-asap"

func handleList(ctx *asap.Context) {
	ctx.Ok()
	return
}
EOF
echo "Done"

# Health Routes
printf "Creating Health Routes"
FILEPATH="api/v1/health/routes.go"
rm -f $FILEPATH
printf "."
touch $FILEPATH
printf "."
cat <<EOF > $FILEPATH
package v1health

import asap "github.com/WaitrInc/go-asap"

func Register() {
	asap.Router.AddResource("health", "v1", ServeHttp)
}

func ServeHttp(ctx *asap.Context) {
	switch ctx.RouteInfo.Method {
	case "LIST":
		handleList(ctx)
	default:
		ctx.MethodNotAllowed()
	}
}
EOF
echo "Done"

# Example Page
printf "Creating Example Page"
FILEPATH="api/v1/example/example.go"
rm -f $FILEPATH
printf "."
touch $FILEPATH
printf "."
cat <<EOF > $FILEPATH
package v1example

import asap "github.com/WaitrInc/go-asap"

func handleList(ctx *asap.Context) {
	ctx.JSONSuccess("LIST works")
	return
}

func handleGet(ctx *asap.Context) {
	ctx.JSONSuccess("GET works: " + ctx.RouteInfo.ResourceID)
	return
}

func handlePost(ctx *asap.Context) {
	ctx.JSONSuccess("POST works")
	return
}

func handlePut(ctx *asap.Context) {
	ctx.JSONSuccess("PUT works")
	return
}

func handleDelete(ctx *asap.Context) {
	ctx.JSONSuccess("DELETE works")
	return
}

func handleCustom(ctx *asap.Context) {
	ctx.Ok()
	return
}
EOF
echo "Done"

# Example Routes
printf "Creating Example Routes"
FILEPATH="api/v1/example/routes.go"
rm -f $FILEPATH
printf "."
touch $FILEPATH
printf "."
cat <<EOF > $FILEPATH
package v1example

import (
	v1subexample "$MODULE_PATH/api/v1/example/subexample"
	asap "github.com/WaitrInc/go-asap"
)

func Register() {
	asap.Router.AddResource("example", "v1", ServeHttp)
	asap.Router.AddSubresource("subexample", "v1", "example", v1subexample.ServeHttp)
}

func ServeHttp(ctx *asap.Context) {
	switch ctx.RouteInfo.Method {
	case "LIST":
		handleList(ctx)
	case "GET":
		handleGet(ctx)
	case "POST":
		handlePost(ctx)
	case "PUT":
		handlePut(ctx)
	case "DELETE":
		handleDelete(ctx)
	default:
		ctx.MethodNotAllowed()
	}
}
EOF
echo "Done"

# Sub Example Page
printf "Creating Sub Example Page"
FILEPATH="api/v1/example/subexample/subexample.go"
rm -f $FILEPATH
printf "."
touch $FILEPATH
printf "."
cat <<EOF > $FILEPATH
package v1subexample

import asap "github.com/WaitrInc/go-asap"

func handleList(ctx *asap.Context) {
	ctx.JSONSuccess("SUB LIST works -  Resource ID: " + ctx.RouteInfo.ResourceID)
	return
}

func handleGet(ctx *asap.Context) {
	ctx.JSONSuccess("GET works - Resource ID: " +
		ctx.RouteInfo.ResourceID +
		"| Sub Resource ID: " +
		ctx.RouteInfo.SubresourceID)
	return
}

func handlePost(ctx *asap.Context) {
	ctx.JSONSuccess("SUB POST works -  Resource ID: " + ctx.RouteInfo.ResourceID)
	return
}

func handlePut(ctx *asap.Context) {
	ctx.JSONSuccess("SUB PUT works -  Resource ID: " + ctx.RouteInfo.ResourceID)
	return
}

func handleDelete(ctx *asap.Context) {
	ctx.JSONSuccess("SUB DELETE works -  Resource ID: " + ctx.RouteInfo.ResourceID)
	return
}

func handleCustom(ctx *asap.Context) {
	ctx.Ok()
	return
}
EOF
echo "Done"

# Sub Example Page
printf "Creating Sub Example Routes"
FILEPATH="api/v1/example/subexample/routes.go"
rm -f $FILEPATH
printf "."
touch $FILEPATH
printf "."
cat <<EOF > $FILEPATH
package v1subexample

import asap "github.com/WaitrInc/go-asap"

func ServeHttp(ctx *asap.Context) {
	switch ctx.RouteInfo.Method {
	case "LIST":
		handleList(ctx)
	case "GET":
		handleGet(ctx)
	case "POST":
		handlePost(ctx)
	case "PUT":
		handlePut(ctx)
	case "DELETE":
		handleDelete(ctx)
	default:
		ctx.MethodNotAllowed()
	}
}
EOF
echo "Done"

# Dockerfile
touch "build/Dockerfile"
#TBD

# Makefile
rm -f "Makefile"
touch "Makefile"
cat <<EOF > Makefile
run:
	go run cmd/$MODULE_NAME/main.go
EOF

echo "Go Getting"
go get github.com/WaitrInc/go-asap

echo "Done"