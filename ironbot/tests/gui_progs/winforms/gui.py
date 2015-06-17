from time import sleep

import clr
clr.AddReference("System.Drawing")
clr.AddReference("System.Windows.Forms")
clr.AddReference("UIAutomationClient")

from System.Drawing import Point
from System.Windows.Forms import Application, Button, Form, Label, CreateParams
from System.Windows.Automation import AutomationElement

class HelloWorldForm(Form):

    def __init__(self):
        self.Text = 'Hello World App'

        self.label = Label()
        self.label.Text = "Please Click Me"
        self.label.Location = Point(50, 50)
        self.label.Height = 30
        self.label.Width = 200

        self.count = 0

        button = Button()
        button.Text = "Click Me"
        button.Location = Point(50, 100)

        button.Click += self.buttonPressed

        self.Controls.Add(self.label)
        self.Controls.Add(button)


    def OnCreateControl(self):
        ae = AutomationElement.FromHandle(self.Handle)
        #ae.

    def buttonPressed(self, sender, args):
        print 'The label *used to say* : %s' % self.label.Text
        self.count += 1
        self.label.Text = "You have clicked me %s times." % self.count

sleep(3)
form = HelloWorldForm()
Application.Run(form)