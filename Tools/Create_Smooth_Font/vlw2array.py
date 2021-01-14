#!/usr/bin/python3
# -*- coding: utf-8 -*-

import sys
from os.path import basename, dirname, splitext, join

path = sys.argv[1]
name = basename(path)
fn, ext = splitext(name)
if ext.lower() != '.vlw':
    print('error: must vlw file.')
    exit(1)

fn = fn.replace('-', '')
arr = []
for idx, c in enumerate(open(path, 'rb').read()):
    if idx and idx % 16 == 0:
        arr.append('\n')
    arr.append('0x%02X, ' % c)

code = '''
#include <pgmspace.h>

const uint8_t %s[] PROGMEM = {
%s
};
''' % (fn, ''.join(arr))

save_path = join(dirname(path), fn + '.h')
open(save_path, 'w').write(code)
