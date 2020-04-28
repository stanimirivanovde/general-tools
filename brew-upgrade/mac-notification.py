#!/usr/local/bin/python

# This script is used to display a Mac OS X notification
# In order to make the notification sticky (alerts) you should
# configure the Notifications settings for Script Editor to 'Alerts'

import os
from optparse import OptionParser

def notify(title, text):
    os.system("""
              osascript -e 'display notification "{}" with title "{}"'
              """.format(text, title))

print('start')
parser = OptionParser(usage='%prog -t TITLE -m MESSAGE')
parser.add_option('-t', '--title', action='store', default='A title')
parser.add_option('-m', '--message', action='store', default='...')

options, args = parser.parse_args()
notify(options.title, options.message)


