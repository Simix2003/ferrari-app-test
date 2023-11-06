import snap7.client as c
import snap7.util as u
from kivy.app import App
from kivy.uix.button import Button
from kivy.uix.gridlayout import GridLayout
from kivy.uix.label import Label
from kivy.clock import Clock

class MyGrid(GridLayout):
    def __init__(self, **kwargs):
        self.client = c.Client()
        self.ip_address = '192.168.1.1'
        self.rack = 0
        self.slot = 2
        self.db_number = 3
        self.start_address = 0
        self.data_size = 1

        super(MyGrid, self).__init__(**kwargs)
        self.cols = 3

        self.client.connect(self.ip_address, self.rack, self.slot) # Connect to PLC

        self.byte_array = self.client.db_read(4, 70, self.data_size)
        self.values = [u.get_bool(self.byte_array, 0, 6)]
        self.value_labels = [Label(text=str(v)) for v in self.values]
        for label in self.value_labels:
            self.add_widget(label)

        button_0 = Button(text='Luce Bagno Doccia')
        button_0.bind(on_press=lambda instance, index=0: self.on_button_toggle_press(instance, index))
        self.add_widget(button_0)

        #button_1 = Button(text='Luce Soggiorno')
        #button_1.bind(on_press=lambda instance, index=1: self.on_button_toggle_press(instance, index))
        #self.add_widget(button_1)

    def update_values(self, dt):
        self.byte_array = self.client.db_read(4, 70, self.data_size)
        self.values = [u.get_bool(self.byte_array, 0, 6)]
        self.value_labels[0].text = str(self.values[0])

    def on_button_toggle_press(self, instance, index):
        if not self.client.get_connected():
            print('CONNECTING')
            self.client.connect(self.ip_address, self.rack, self.slot)

        if self.client.get_connected():
            self.values[index] = 1  # toggle the value you want to write to the PLC
            byte_array = bytearray(1)  # create a byte array of length 1
            u.set_bool(byte_array, 0, 0, self.values[index])  # set the boolean value in the byte array
            self.client.db_write(self.db_number, index, byte_array)  # write the byte array to the PLC
            Clock.schedule_once(self.update_values, 0.5)  # call update_values after 1.0 seconds

class MyApp(App):
    def build(self):
        return MyGrid()

if __name__ == '__main__':
    MyApp().run()
