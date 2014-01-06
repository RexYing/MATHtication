import bpy

import os
import csv

import xml.etree.ElementTree as ET

class DataLoader:
    root_dir = ""
    
    def __init__(self, filename):
        filepath = bpy.data.filepath
        self.root_dir = filepath[0: filepath.find('visualization') - 1]
        filepath = os.path.join(self.root_dir, 'data', filename)
        tree = ET.parse(filepath)
        self.root = tree.getroot()
        
    def get_axes_by_name(self, name):
        ret = {}
        if self.root.find('axes').find(name) == None:
            return;
        
        # Lower jaw axes
        coords = []
        for axis in self.root.find('axes').find(name).find('lower'):
            coords += axis.text.split(',')
        coords = [float(num) for num in coords]
        ret['lower'] = coords;
        
        # Upper jaw axes
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
        axes_dict['adacrop'] = self.get_axes_by_name('axes_adaptive_crop');
        return axes_dict
    
    '''
    Load index classification, in order to display them in different colors.
    ''' 
    def load_inds(self, filename):
        inds = []
        filename = os.path.join(self.root_dir, 'data', filename)
        with open(filename, 'rt') as csvfile:
            reader = csv.reader(csvfile)
            for row in reader:
                inds += [int(num) for num in row]
        return inds
        

#loader = DataLoader('jaw1.xml')
#axes_dict = loader.load_axes()
#print(axes_dict['sample'])
#print(axes_dict['raw'])


