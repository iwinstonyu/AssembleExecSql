# coding: utf-8

import os
import glob
import io
import getopt
import sys

in_path = None
out_path = None

def print_usage():
	print('Usage: -i[input path] -o[output path]')
	
opts,args = getopt.getopt(sys.argv[1:], 'i:o:', ['help'])
for name, value in opts:
	if name in ['--help']:
		print_usage()
		exit(1)
	elif name in ['-i']:
		in_path = value
	elif name in ['-o']:
		out_path = value
		
if in_path is None or out_path is None:
	print_usage()
	exit(1)
	
print("Input path: {}".format(in_path))
print("Output path: {}".format(out_path))

f_out = open(out_path, "wb")

glob_path = "{}/*.sql".format(in_path)
print("Glob path: {}".format(glob_path))

for sql_file_path in glob.glob(glob_path):
	sql_file_name = os.path.basename(sql_file_path)
	print("Reading file: {}".format(sql_file_name))
	f_sql = open(sql_file_path, 'rb')
	f_out.write("#=========================================\r\n".encode())
	f_out.write("#{}\r\n".format(sql_file_name).encode())
	f_out.write("#=========================================\r\n".encode())
	f_out.write("select '{}';\r\n".format(sql_file_name).encode())
	f_out.write(f_sql.read())
	f_out.write("\r\n\r\n".encode())
	f_sql.close()
	
f_out.close()
