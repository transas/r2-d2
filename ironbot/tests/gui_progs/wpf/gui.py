from os.path import join, dirname

MY_DIR = dirname(__file__)


# Reference the WPF assemblies
import clr
clr.AddReferenceByName("PresentationFramework, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35")
clr.AddReferenceByName("PresentationCore, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35")
import System.Windows

# Initialization Constants
Window = System.Windows.Window
Application = System.Windows.Application
Button = System.Windows.Controls.Button
StackPanel = System.Windows.Controls.StackPanel
Label = System.Windows.Controls.Label
Thickness = System.Windows.Thickness
DropShadowBitmapEffect = System.Windows.Media.Effects.DropShadowBitmapEffect


import wpf

class AboutWindow(Window):
    def __init__(selfAbout):
        wpf.LoadComponent(selfAbout, join(MY_DIR, 'AboutWindow.xaml'))

    def Click1(self, sender, e):
        self.textBlock1.Text = "Click1"

    def Click2(self, sender, e):
        self.textBlock1.Text = "Click2"

class MyWindow(Window):
    def __init__(self):
        wpf.LoadComponent(self, join(MY_DIR, 'IronPythonWPF.xaml'))
        #print dir(self.listBox1)
        self.listBox1.AddText('ABC')
        self.listBox1.AddText('DEF')
        self.listBox1.AddText('GHI')


    def Button1_Click(self, sender, e):
        form = AboutWindow()
        form.Show()

    def Button2_Click(self, sender, e):
        form = AboutWindow()
        form.ShowDialog()

    def MenuItem_Click(self, sender, e):
        form = AboutWindow()
        form.Show()

if __name__ == '__main__':
    Application().Run(MyWindow())
