#!/usr/bin/python
# -*- coding: utf-8 -*-

# (c) 2016, Stanley Karunditu <stanley@linuxsimba.com>
#
# This file is part of Ansible
#
# Ansible is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ansible is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ansible.  If not, see <http://www.gnu.org/licenses/>.

# this is a windows documentation stub.  actual code lives in the .ps1
# file of the same name

DOCUMENTATION = '''
---
module: win_host
version_added: "2.0"
short_description: Manange Host File
description:
  - Manangae host file entry in Windows
options:
  host_name:
    description: name of the host to add to
    required: yes
  ip_address:
    description: ip address of the host to add to
    required: yes
  state:
    description: if present then add the membership. if absent the delete the membership
    choices: ['present', 'absent']
    default: 'present'
author: Ripon Banik(ripon.banik@yahoo.com)
'''

EXAMPLES = '''
# Add Host
$ ansible -i hosts -m win_host -a "host_name=host ip_address=ip" windows
'''