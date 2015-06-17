"""
>>> class dict1(dict): pass
>>> class list1(list): pass
>>> attrs = AttributeDict()
>>> attrs.add_attr("a1", 0, get=(), set=(test_pop,),)
>>> attrs.add_class_attr("dict", "a1", get=lambda x: x['a1'], set=lambda x, v: x.update({'a1': v}) )
>>> attrs.add_class_attr("dict1", "a1", get=lambda x: x['a1_'], set=lambda x, v: x.update({'a1_': v}) )
>>> attrs.add_class_attr("list", "a1", get=lambda x: x[-1], set=lambda x, v: x.append(v))
>>> src = [1]; d = {}; l = []; d1 = dict1(d); l1 = list1(l)
>>> attrs.read_params("a1", "get", [])
[]
>>> attrs.read_params("a1", "set", src), src
([1], [])
>>> attrs.action(d, "a1", "get", []), attrs.action(l, "a1", "get", []), attrs.action(d1, "a1", "get", []), attrs.action(l1, "a1", "get", [])
(0, 0, 0, 0)
>>> attrs.action(d, "a1", "set", [1]); attrs.action(l, "a1", "set", [1]); attrs.action(d1, "a1", "set", [1]); attrs.action(l1, "a1", "set", [1])
>>> attrs.action(d, "a1", "get", []), attrs.action(l, "a1", "get", []), attrs.action(d1, "a1", "get", []), attrs.action(l1, "a1", "get", [])
(1, 1, 1, 1)
>>> d, l, d1, l1
({'a1': 1}, [1], {'a1_': 1}, [1])
"""

import re
import traceback
import logging
from _util import IronbotException


def test_pop(params):
    res = params[0]
    del params[0]
    return res


def test_print(params):
    print params


def test_op(a, b):
    a.append(b)
    return a


class AttributeOperation(object):
    """
    >>> o = AttributeOperation(test_op)
    >>> o.argc
    1
    >>> obj=[1]; o(obj, 2); obj
    [1, 2]
    [1, 2]
    """
    def __init__(self, op):
        self.argc = op.func_code.co_argcount - 1
        assert self.argc >= 0
        self.f = op

    def __call__(self, obj, *a):
        return self.f(obj, *a)



class Attribute(object):
    def __init__(self, name, default=None, **kw):
        self.name = name
        self.actions = kw
        self.default = default
        self.class_attrs = {}

    def find_class_attr(self, obj):
        for t in type(obj).mro():
            if t.__name__ in self.class_attrs:
                return self.class_attrs[t.__name__]
        return None


class ClassAttribute(object):
    def __init__(self, class_name, **kw):
        self.class_name = class_name
        self.actions = kw
        for a in self.actions:
            self.actions[a] = AttributeOperation(self.actions[a])


class AttributeDict(object):
    def __init__(self):
        self.attributes = {}

    def add_attr(self, name, default=None, **kw):
        self.attributes[name] = Attribute(name, default, **kw)

    def add_class_attr(self, class_name, name, **kw):
        a = self.attributes[name]
        a.class_attrs[class_name] = ClassAttribute(class_name, **kw)

    def read_params(self, name, action, args):
        a = self.attributes[name]

        return [pop_f(args) for pop_f in a.actions[action]]


    """def get_action_function(self, name, action, params):
        a = self.attributes[name]
        ca = a.find_class_attr(obj)
        if ca:
            def f(o):
                try:
                    return ca.actions[action](obj, *params)
                except:
                    return a.default
            return f
        return lambda _: a.default"""


    def action(self, obj, name, action, params):
        #return self.get_action_function(name, action, params)(obj)
        a = self.attributes[name]
        ca = a.find_class_attr(obj)
        if ca:
            try:
                return ca.actions[action](obj, *params)
            except:
                logging.warning(traceback.format_exc())
        return a.default


def attr_checker(attr_name):
    def f(obj, val):
        return my_getattr(obj, attr_name) == val
    return f


def attr_reader(attr_name):
    def f(obj):
        return my_getattr(obj, attr_name)
    return f


def re_checker(attr_name):
    def f(obj, val):
        r = re.compile(val)
        return r.match(my_getattr(obj, attr_name)) is not None
    return f

def my_getattr(obj, an):
    """
    >>> class t: pass
    >>> a = t(); a.b = t(); a.b.c = 1
    >>> my_getattr(a, "b.c")
    1
    """
    for attr in an.split('.'):
        obj = getattr(obj, attr)
    return obj
