import bpy

import os

import xml.etree.ElementTree as ET

class DataLoader:
    
    def __init__(self, filename):
        filepath = bpy.data.filepath
        root_dir = filepath[0: filepath.find('visualization') - 1]
        filepath = os.path.join(root_dir, 'data', filename)
        tree = ET.parse(filepath)
        self.root = tree.getroot()
        
    def get_axes_by_name(self, name):
        ret = {}
        coords = []
        for axis in self.root.find('axes').find(name).find('lower'):
            coords += axis.text.split(',')
        coords = [float(num) for num in coords]
        ret['lower'] = coords;
        
        coords = []
        for axis in self.root.find('axes').find(name).find('upper'):
            coords += axis.text.split(',')
        coords = [float(num) for num in coords]
        ret['upper'] = coords;
        return ret;

    def load_axes(self):
        axes_dict = {}
        axes_dict['raw'] = self.get_axes_by_name('axes_raw');
        axes_dict['sample'] = self.get_axes_by_name('axes_FM');
        return axes_dict

#loader = DataLoader('jaw1.xml')
#axes_dict = loader.load_axes()
#print(axes_dict['sample'])
#print(axes_dict['raw'])

