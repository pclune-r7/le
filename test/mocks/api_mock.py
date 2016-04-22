#!/usr/bin/env python2

#
# Logentries API server mock
#

import cyclone.web
import sys
import os

import json

from twisted.python import log
from twisted.internet import reactor
from cyclone.web import asynchronous

CWD = os.getcwd()

HOST0_KEY = "41ae887a-284a-4d78-91fe-56485b076148"
HOST1_KEY = "86707421-6a05-4c70-9034-e5e30b6a1a44"
HOST2_KEY = "9df0ea6f-36fa-820f-a6bc-c97da8939a06"
LOG0_KEY = "400da462-36fa-48f4-bb4e-87f96ad34e8a"
LOG1_KEY = "ee0489cc-41ce-41cf-9bb6-4cdf5e5acf32"
LOG2_KEY = "484d6e95-a4e1-42fe-820f-5a4c0824428c"
LOG3_KEY = "fa32313c-3907-4214-ac41-3ff9c6549a22"
LOG_DYNAMIC_KEY = "32fa313c-4c70-4214-9bb6-3ff9c6549a22"

LOG0 = {
    "object":"log",
    "key":LOG0_KEY,
    "name":"Log name 0",
    "filename":CWD +"/example.log",
    "created":1414611930412,
    "type":"agent",
    "follow":"true",
    "retention":-1,
}

LOG1 = {
    "object":"log",
    "key":LOG1_KEY,
    "name":"Log name 1",
    "filename":CWD +"/example2.log",
    "created":1418775058756,
    "type":"token",
    "logtype":"444e607f-14bd-405e-a2ce-c4892b5a3b15",
    "follow":"false",
    "retention":-1,
    "token": "120fb800-94c0-446a-be28-cfbbc36b52eb"
}

# LOG-7549 Test case
LOG2 = {
    "object":"log",
    "key":LOG2_KEY,
    "name":"Apache",
    "filename":"Multilog:" + CWD +"/apache*/current",
    "created":1418711930412,
    "type":"agent",
    "follow":"true",
    "retention":-1,
}

# LOG-7549 Test case
LOG3 = {
    "object":"log",
    "key":LOG3_KEY,
    "name":"current",
    "filename":"Multilog:" + CWD +"/apache-01/current",
    "created":1418711930412,
    "type":"agent",
    "follow":"true",
    "retention":-1,
}

HOST0 = {
    "object":"host",
    "key":HOST0_KEY,
    "hostname":"0.example.com",
    "c":1315863111149,
    "distname":"Debian",
    "name":"Name1",
    "distver":"wheezy",
}

HOST1 = {
    "object":"host",
    "key":HOST1_KEY,
    "hostname":"1.example.com",
    "c":1385398282448,
    "distname":"Debian",
    "name":"Name2",
    "distver":"jessie",
}

HOST2 = {
    "object":"host",
    "key":HOST2_KEY,
    "hostname":"2.example.com",
    "c":1385398282559,
    "distname":"Debian",
    "name":"Multilog",
    "distver":"jessie",
}


class ApiHandler( cyclone.web.RequestHandler):
    def get( self):
        self.write( "API mock server is running")

    def post( self):
        request = self.get_argument( 'request')
        if request == 'register':
            distver = self.get_argument( 'distver')
            name = self.get_argument( 'name')
            distname = self.get_argument( 'distname')
            hostname = self.get_argument( 'hostname')
            self.write( json.dumps( {
                'response': 'ok',
                'host_key': HOST0_KEY,
                'agent_key': HOST0_KEY,
                'host': {
                    'object': 'host',
                    'key': HOST0_KEY,
                    'hostname': hostname, # XXX
                    'c': 1315863111149,
                    'distname': distname,
                    'name': name,
                    'distver': distver,
                },
                'worker': 'a0',
            }))
        elif request == 'new_log':
            host_key = self.get_argument( 'host_key')
            if host_key == HOST0_KEY:
                self.write( json.dumps( {
                    'response': 'ok',
                    'log_key': LOG0_KEY,
                    'log': LOG0,
                    'worker': 'a0',
                }))
            elif host_key == HOST1_KEY:
                self.write( json.dumps( {
                    'response': 'ok',
                    'log_key': LOG1_KEY,
                    'log': LOG1,
                    'worker': 'a0',
                }))
            elif host_key == HOST2_KEY:
                logname = self.get_argument('name')
                filename = self.get_argument('filename')
                follow = self.get_argument('follow')
                self.write( json.dumps( {
                    'response': 'ok',
                    'log_key': LOG_DYNAMIC_KEY,
                    'log': {
                        "object":"log",
                        "key":LOG_DYNAMIC_KEY,
                        "name":logname,
                        "filename":filename,
                        "created":1418711930412,
                        "type":"agent",
                        "follow":follow,
                        "retention":-1,
                    },
                    'worker': 'a0',
                }))
        elif request == 'get_user':
            load_logs = self.get_argument('load_logs')
            resp = {
                'response': 'ok',
                'hosts': [ HOST0, HOST1 ]
            }
            if load_logs == 'true':
                resp['hosts'][0]['logs'] = [ LOG0 ]
                resp['hosts'][1]['logs'] = [ LOG1 ]
            self.write( json.dumps( resp))
        else:
            raise cyclone.web.HTTPError( 400)

class AccountHandler( cyclone.web.RequestHandler):
    def get( self, account_id):
        self.write( json.dumps({
            "response":"ok",
            "object":"rootlist",
            "list":[
                {
                    "name":"logs",
                    "key":""
                },{
                    "name":"hosts",
                    "key":""
                },{
                    "name":"hostnames",
                    "key":""
                },{
                    "name":"apps",
                    "key":""
                },{
                    "name":"clusters",
                    "key":""
                },{
                    "name":"logtypes",
                    "key":""
                }],
            }))

class HostsHandler( cyclone.web.RequestHandler):
    def get( self, account_id):
        self.write( json.dumps({
            "response":"ok",
            "object":"hostlist",
            "list":[ HOST0, HOST1 ],
        }))

class HostHandler( cyclone.web.RequestHandler):
    def get( self, account_id, host_id):
        if host_id in [HOST0_KEY, HOST0['name']]:
            self.write( response_ok( HOST0))
        elif host_id in [HOST1_KEY, HOST1['name']]:
            self.write( response_ok( HOST1))
        else:
            raise cyclone.web.HTTPError( 403)

class HostLogsHandler( cyclone.web.RequestHandler):
    def get( self, account_id, host_id):
        if host_id in [HOST0_KEY, HOST0['name']]:
            self.write( response_ok( {
                "object":"loglist",
                "list":[ LOG0, LOG1],
            }))
        elif host_id in [HOST1_KEY, HOST1['name']]:
            self.write( response_ok( {
                "object":"loglist",
                "list":[],
            }))
        elif host_id in [HOST2_KEY, HOST2['name']]:
            self.write( response_ok( {
                "object":"loglist",
                "list":[LOG2],
            }))
        else:
            raise cyclone.web.HTTPError( 403)

class LogHandler( cyclone.web.RequestHandler):
    def get( self, account_id, host_id, log_id):
        if log_id in [LOG0_KEY, LOG0['name']]:
            self.write( response_ok( LOG0))
        elif log_id in [LOG1_KEY, LOG1['name']]:
            self.write( response_ok( LOG1))

class IngestionHandler( cyclone.web.RequestHandler):
    @asynchronous
    def put( self, account_id, host_id, log_id):
        if log_id in [LOG0_KEY, LOG0['name']]:
            pass
        elif log_id in [LOG1_KEY, LOG1['name']]:
            pass
        elif log_id in [LOG2_KEY, LOG2['name']]:
            pass
        elif log_id in [LOG3_KEY, LOG3['name']]:
            pass

def response_ok( x):
    a = { 'response': 'ok'}
    a.update( x)
    return json.dumps( a)

if __name__ == "__main__":
    application = cyclone.web.Application([
        (r"/", ApiHandler),
        (r"/([a-z0-9-]+)/", AccountHandler),
        (r"/([a-z0-9-]+)/hosts", HostsHandler),
        (r"/([a-z0-9-]+)/hosts/([a-zA-Z0-9%-]+)", HostHandler),
        (r"/([a-z0-9-]+)/hosts/([a-zA-Z0-9%-]+)/", HostLogsHandler),
        (r"/([a-z0-9-]+)/hosts/([a-zA-Z0-9%-]+)/([a-zA-Z0-9%-]+)", LogHandler),
        (r"/([a-z0-9-]+)/hosts/([a-zA-Z0-9%-]+)/([a-zA-Z0-9%-]+)/.*", IngestionHandler),
    ])
    log.startLogging( sys.stdout)
    reactor.listenTCP( 8081, application)
    reactor.run()

