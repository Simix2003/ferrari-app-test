from flask import Flask, jsonify, request
import snap7.client as c
import snap7.util as u
from kivy.app import App
from kivy.uix.button import Button
from kivy.uix.gridlayout import GridLayout
from kivy.uix.label import Label
from kivy.clock import Clock

app = Flask(__name__)

class Avdel_Connection:
    def __init__(self):
        self.client = c.Client()
        self.ip_address = '192.168.1.1'
        self.rack = 0
        self.slot = 2
        self.db_number = 7
        self.start_address = 0
        self.data_size = 1
        self.color_db_number = 4
        self.color_byte_index = 0
        self.color_bit_index = 0
        self.db_number_num_pezzi = 8
        self.start_address_num_pezzi = 0
        self.data_size_num_pezzi = 2

        self.client.connect(self.ip_address, self.rack, self.slot)

    def read_bool_value(self):
        byte_array = self.client.db_read(self.db_number, self.start_address, self.data_size)
        value = u.get_bool(byte_array, 0, 6)

        color_byte_array = self.client.db_read(self.color_db_number, self.color_byte_index, self.data_size)
        color_status = u.get_bool(color_byte_array, 0, self.color_bit_index)

        return value, color_status


    def write_bool_value(self, value):
        byte_array = bytearray(1)
        u.set_bool(byte_array, 0, 0, value)
        self.client.db_write(self.db_number, self.start_address, byte_array)

        # Update the color status in the PLC's DB
        color_byte_array = bytearray(1)
        u.set_bool(color_byte_array, 0, 0, value)
        self.client.db_write(self.db_number, self.start_address + 1, color_byte_array)

    def read_num_pezzi(self):
        byte_array = self.client.db_read(self.db_number_num_pezzi, self.start_address_num_pezzi, self.data_size_num_pezzi)
        num_pezzi = u.get_int(byte_array, 0)
        return num_pezzi


    def write_num_pezzi(self, value):
        byte_array = bytearray(1)
        u.set_int(byte_array, 0, value)
        self.client.db_write(self.db_number_num_pezzi, self.start_address_num_pezzi, byte_array)


Avdel = Avdel_Connection()

@app.route('/api/Avdel_Value', methods=['GET'])
def get_bool_value():
    value = Avdel.read_bool_value()
    return jsonify({"value": value}) 

@app.route('/api/Avdel_Value', methods=['POST'])
def set_bool_value():
    data = request.get_json()
    value = data.get('value', 0)
    Avdel.write_bool_value(value)
    return jsonify({"message": "Boolean value updated successfully"})

@app.route('/api/Avdel_Value', methods=['GET'])
def get_bool_and_color():
    bool_value, color_status = Avdel.read_bool_value()
    return jsonify({"value": bool_value, "color_status": color_status})

@app.route('/api/OP40_Value', methods=['GET'])
def get_num_pezzi():
    value = Avdel.read_num_pezzi()
    return jsonify({"pezzi": value}) 

@app.route('/api/OP40_Value', methods=['POST'])
def set_num_pezzi():
    data = request.get_json()
    value = data.get('pezzi', 0)
    Avdel.write_num_pezzi(value)
    return jsonify({"message": "Int value updated successfully"})

if __name__ == '__main__':
    app.run(host='0.0.0.0')