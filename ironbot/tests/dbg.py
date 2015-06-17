#Import this file to try working with White in IronPython console

try:
    import clr
    clr.AddReference("White.Core")
    clr.AddReference("System")
    clr.AddReference("System.Core")
    clr.AddReference("UIAutomationClient")
    clr.AddReference("UIAutomationTypes")



    import White.Core.Application as Application
    from System.Diagnostics import ProcessStartInfo, Process
    import White.Core.Desktop as Desktop
    from System.Windows.Automation import AutomationProperty, AutomationElement

    from White.Core.UIItems.Finders import SearchCriteria

    from White.Core.UIItems import Button, TextBox, RadioButton, Label

    from White.Core.UIItems.ListBoxItems import ListBox, ListItem
    #import White.Core.UIItems
    #logging.warning(repr(dir(White.Core.UIItems)))
    #from White.Core.UIItems.TreeItems import Tree, TreeNode
    #from White.Core.UIItems.WindowItems import Window, DisplayState
    #from White.Core.UIItems.WindowStripControls import ToolStrip, MenuBar
    from White.Core.UIItems.MenuItems import Menu
    #from White.Core.UIItems.ListBoxItems import ComboBox
    #from White.Core.UIItems.TableItems import Table

    #from System.Windows.Automation import ControlType

    #logging.warning(repr(dir(ControlType)))


except:
    from traceback import format_exc
    logging.error(format_exc())
