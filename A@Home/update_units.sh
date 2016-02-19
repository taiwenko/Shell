#!/bin/sh

###############################################################################
# This script will be used to insert, report and remove ALT units into the
# DHCP clients table.
# 
# Created By: Clinton Lazzari
# Last Modified By: Clinton Lazzari
#
# Revisions
# Rev 0.1 - 01/12/12 - Initial documentation and pseudo code
#
# External Requirements: None
# 
# Written and tested on Ubuntu 10.04
#
###############################################################################

###############################################################################
#
# User Interface
#
# Used to check the correct arguments are passed
#
###############################################################################

if [ $# -gt 1 && -lt 3