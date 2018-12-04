#!/usr/bin/env python
import os
import argparse
def get_file_paths(directory):

    file_paths = []

    for root, directories, files in os.walk(directory):
        for filename in files:
            file_path = os.path.join(root, filename)
            file_paths.append(file_path)

            return file_paths

def find_largest_file(directory, max_size):

    full_file_paths = get_file_paths(directory)
    size_mb = 0

    for file_path in full_file_paths:
        if os.path.isfile(file_path):
            size_mb = ((os.path.getsize(file_path)) / 1024) / 1024
        if size_mb > max_size:
            print(file_path)
            print('size: {} mb'.format(size_mb))
        else:
            print('can not read file:')
            print(file_path)
        return size_mb

def main():

    root_dir = argparse.arg[1]
    result_size = 0
    dir_list = os.walk(os.path.join(root_dir, '.')).next()[1]

    print(root_dir)
    print('-----------------------------')
    for cur_dir in dir_list:
        print('processing {0} |...').format(cur_dir)
        result_size = find_larget_file(root_dir + '\\' + cur_dir, 1000)
        print('-------------------------------')
        print(result_size)

if __name__ == "__main__":
    main()
