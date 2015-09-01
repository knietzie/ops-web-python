#!/usr/bin/env python
import cgi
import math


print "Content-type: text/html"


exp = input('Enter base and exponent, separated by comma.\n') 

print '= %d \n' % math.pow(*exp)