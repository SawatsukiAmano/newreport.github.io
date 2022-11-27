---
title: beego拦截器及CORS
copyright: true
date: 2022-11-27 00:00:00
urlname: beego-filter-cors
categories: golang
---
> 跨域仅为浏览器的安全策略，对于其他形式的 http client（ postman，自己写的 python client 、java client 等 ）无效

```go
package routers

import (
    "short_url_go/controllers"
    "strings"

    "github.com/beego/beego/v2/server/web/context"
    cors "github.com/beego/beego/v2/server/web/filter/cors"

    "github.com/beego/beego/logs"
    beego "github.com/beego/beego/v2/server/web"
)


var FilterToken = func(ctx *context.Context) {
    ctx.Output.Header("Access-Control-Allow-Origin", "*")
    logs.Info("current router path is ", ctx.Request.RequestURI)
        ctx.Request.RequestURI != "/v1/users/login" &&
        ctx.Request.RequestURI != "/v1/users/register" &&
        ctx.Request.RequestURI != "/v1/users/tocken/account"&& {
        if ctx.Input.Header("Authorization") == "" {
            logs.Error("without token, unauthorized !!")
            ctx.ResponseWriter.WriteHeader(401)
            ctx.ResponseWriter.Write([]byte("no permission"))
        } else {
            token := ctx.Input.Header("Authorization")
            token = strings.Split(token, " ")[1]
            logs.Info("curernttoken: ", token)
            ok := controllers.AuthenticationJWT(token)
            if !ok {
                ctx.ResponseWriter.WriteHeader(401)
                ctx.ResponseWriter.Write([]byte("no permission"))
            }
        }
    }
}

func init() {
        //过滤器为顺序执行，所以要先CORS再鉴权，
        //过滤器1,允许跨域
    beego.InsertFilter("*", beego.BeforeRouter, cors.Allow(&cors.Options{
        AllowAllOrigins: true,
        AllowMethods:    []string{"GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"},
        //Get：获取数据幂等操作
    }))
        //过滤器2,token
    beego.InsertFilter("*", beego.BeforeRouter, FilterToken)
    ns := beego.NewNamespace("/v1",
        beego.NSNamespace("/users",
            beego.NSInclude(
                &controllers.UserController{},
            ),
        ),
        beego.NSNamespace("/shorts",
            beego.NSInclude(
                &controllers.ShortController{},
            ),
        ),
    )
    beego.AddName
