import datetime
from SimpleXMLRPCServer import SimpleXMLRPCServer
import xmlrpclib

ERROR_WINDOWS = {}

def register_error_window(w_info):
    today = datetime.datetime.today()
    return xmlrpclib.DateTime(today)

def unregister_error_window(w_info):
    if w_info in ERROR_WINDOWS:
        ERROR_WINDOWS[w_info] -= 1
        if ERROR_WINDOWS[w_info] <= 0:
        del ERROR_WINDOWS[w_info]
        return True

server = SimpleXMLRPCServer(("localhost", 8000), encoding='utf8')
server.register_function(today, "today")
server.serve_forever()
