/// <reference path="typings/tsd.d.ts" />

var express = require('express');
var http = require('http');
var cookieParser = require('cookie-parser');
var session = require('express-session');
var logger = require('morgan');
var request = require('request');
var multipart = require('connect-multiparty');
var webApp = express();
var server = http.createServer(webApp);
webApp.use(multipart());
var stsUrl = process.env.stsUrl || "http://localhost:3555";
var apiUrl = process.env.apiURL || "http://localhost:3000";
var port   = process.env.port   || 8787;

webApp.use(cookieParser());
webApp.use(logger('dev'));


webApp.get('/ping', (req, res) => {
    res.send('OK');
});

webApp.get('/authenticate/:token', (req, res) => {
    //proxy the sts request
    request(stsUrl + '/token/' + req.params.token, (error, response, body) => {
        if (!error && response.statusCode == 200 && body) {
            res.cookie('oscauth', body, { maxAge: 86400000 * 365, secure: false, httpOnly: false}); //Secure true over https only
            res.redirect('/');
        } else {
            res.cookie('oscauth', body, { maxAge: 86400000 * 365, secure: false, httpOnly: false}); //Secure true over https only
            res.redirect('/');
        }
    });
});


//Read the auth cookie and add the user into the request
webApp.use(function(req, res, next){
    //reject the request when the user is not authorized
    if(!req.cookies['oscauth']){
        res.redirect(stsUrl);
        return;
    }
    
    next();
});

webApp.use(express.static(__dirname + '/client'));
webApp.use(express.static(__dirname + '/data'));

webApp.get('/config', (req, res) => {
    var settings = {apiUrl: apiUrl, loginUrl: stsUrl};
    res.json(settings);
});

webApp.get('/user', (req, res) => {
    res.json(req.cookies.oscauth);
});



webApp.listen(port);
console.log('Listening on http://localhost:' + port);
