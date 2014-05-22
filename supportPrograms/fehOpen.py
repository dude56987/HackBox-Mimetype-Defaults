#! /usr/bin/python
########################################################################
# This dont do shit yet
# Copyright (C) 2013  Carl J Smith
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
########################################################################
# FehOpen : requires the program feh be installed on a linux box
# Takes a file and opens it in feh so that the user can browse the 
# entire directory by clicking the mouse. Command needs a single 
# filename fed into it. It can not handle anything else.
import sys
from os import system
from os.path import abspath
from re import sub
# takes supplied directory from call and splits it based on / charcters into array
directory = abspath(sys.argv[1]).split('/')
temp = ''
count = 0
# for each item in array that is directory path
for i in directory:
	# if array item is empty do nothing this is for begining of string
	if i == '':
		pass
	else:
		# count lets the program skip the filename	
		if count != (len(directory)-1):
			# this creates a var that will be the working directory
			temp += ('/'+i)
	count += 1
# make the path to grab all other files inside the folder so user can click
# though photos in folder (feh will fail silently for non image files)
directory = temp + '/*.*'
# convert spaces to escaped spaces so spaced dont cause program to fail
directory = sub(" ","\ ",directory)
filePath = sub(' ','\ ',abspath(sys.argv[1]))
# convert and statements to be escaped and pipes to be escaped
directory = sub("&","\&",directory)
filePath = sub('&','\&',filePath)
# clear temp
temp = None
# place command line system call using minipulated data
system('feh '+filePath+' '+directory+' -g 800x600')
