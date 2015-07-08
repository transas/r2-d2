from impl._white_core import app_launch, app_state, app_attach
from impl._white_core import proc_list, proc_filter, proc_attr
from impl._white_core import wnd_get, wnd_filter, wnd_attr
from impl._white_core import ctl_get, ctl_attr
from impl._white_core import kbd_attr

ROBOT_LIBRARY_SCOPE = 'GLOBAL'


class _Listener:
    ROBOT_LISTENER_API_VERSION = 2

    def __init__(self):
        pass

    def start_suite(self, name, attrs):
        from impl._white_core import on_enter_suite
        on_enter_suite()
        from logging import warning
        warning("START SUITE %s" % name)

    def start_test(self, name, attrs):
        from impl._white_core import on_enter_test
        on_enter_test()

    def end_test(self, name, attrs):
        from impl._white_core import on_leave_test
        on_leave_test()

    def end_suite(self, name, attrs):
        from impl._white_core import on_leave_suite
        on_leave_suite()
        from logging import warning
        warning("END SUITE %s" % name)

    def close(self):
        pass


ROBOT_LIBRARY_LISTENER = _Listener()

del _Listener
