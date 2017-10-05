#!powershell
# 
# Copyright 2017, Ripon Banik <ripon.banik@yahoo.com>
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

# Not quite sure what these do..but I see it in all powershell examples, so just leave it here.
# WANT_JSON
# POWERSHELL_COMMON

# Ansible Windows PowerShell Template
Set-StrictMode -Version 2.0

function add_host($host_name,$ip_address) {

    If ((Get-Content "$($env:windir)\system32\Drivers\etc\hosts" ) -contains  "$ip_address $host_name")  {
        $result.msg = "Entry already exists in host file"      
        $result.changed = $false         
    } 
    else {      
      Add-Content -Encoding UTF8  "$($env:windir)\system32\Drivers\etc\hosts" "$ip_address $host_name"      
      $result.msg = "Successfully added to host file"      
      $result.changed = $true
    } 
}    

function remove_host($host_name,$ip_address) {

    If ((Get-Content "$($env:windir)\system32\Drivers\etc\hosts" ) -contains  "$ip_address $host_name")  {
        (Get-Content "$($env:windir)\system32\Drivers\etc\hosts" ) | select-string -pattern "$ip_address $host_name" -notmatch | Set-Content "$($env:windir)\system32\Drivers\etc\hosts"
        $result.msg = "Successfully removed from host file"      
        $result.changed = $true
    } 
    else {            
      $result.msg = "Entry does not exist in host file"      
      $result.changed = $false
    } 
}    


# Parse the Keywords from the ansible module call
# Example: if the module command looks like this
# ----
# ansible -m win_host command -a "host_name='host',ip_address='ip'" windowshost
# ----
# Then Parse-Args $args attributes like this
$params = Parse-Args $args;

# Create a new object. Call it result. This will store the information you want to print
# out in the json result string when the module exits. By default its a good idea to add
# the "changed" and "msg" attributes.
# When "changed" == "false" it means that no action was taken to change the system. It is also
# a good idea to update the "msg" attribute and mention why no change occurred.
#$result = New-Object psobject;
#Set-Attr $result "changed" $false;
#Set-Attr $result "msg" "";

# Changed the above in Ansible 2.4 - http://docs.ansible.com/ansible/2.4/dev_guide/developing_modules_general_windows.html#windows-new-module-development
$result = @{}
$result.changed = $false
$result.msg = ""

# Extract each attribute into a variable. During this stage you can perform various checks.
# 1. Like checking if the attribute is empty. If it is, then exit the module with a failure
$host_name  = Get-Attr $params "host_name"  -failifempty $true
$ip_address = Get-Attr $params "ip_address" -failifempty $true

# New in Ansible 2.4
#$host_name  = Get-AnsibleParam -obj $params -name "host_name" -type "str" -failifempty $true
#$ip_address = Get-AnsibleParam -obj $params -name "ip_address" -type "str" -failifempty $true

#Set-Attr $result "host_name"  $host_name;
#Set-Attr $result "ip_address" $ip_address;

$result.host_name  = $host_name
$result.ip_address = $ip_address

# 3. Set default state of an attribute. In this case the "state" attribute is set to "present" if not set.
  $state = Get-Attr $params "state" "present"
  $state = $state.ToString().ToLower()
  If (($state -ne "present") -and ($state -ne "absent")) {
      Fail-Json $result "state is '$state'; must be 'present' or 'absent'"
  }
  if ($state -eq "present") {
    add_host $host_name $ip_address
  }
  elseif ($state -eq "absent") {
    remove_host $host_name $ip_address
  }

# Finally always return the $result attribute. This will have the "changed", "msg" and any other attribute
# you want to add to the JSON output string
Exit-Json $result