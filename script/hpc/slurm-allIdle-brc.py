#!/usr/bin/env python3

# should have been a simple script that submit job to all idle nodes
# becoming a longish python script
# adopted from bofhbot


import os
import re # regex
import time
import argparse
import shlex
import sys
import subprocess
import getpass
from multiprocessing import Pool, cpu_count
from shutil import copyfile 
from dateutil import parser
import time

# global param :)  better as OOP get() fn or some such.  
#sinfoNfile = '/var/tmp/sinfoN.txt'
sinfoNfile = './.sinfoN.txt'
#sinfoRSfile = 'sinfo-RSE-eg.txt.head5'
#nodeColumnIndex=3
nodeColumnIndex=0   # node is 0th column in output of sinfo --Node ...

# programmer aid fn
# dbgLevel 3 (ie -ddd) is expected by user troubleshooting problem parsing input file
# currently most detailed output is at level 5 (ie -ddddd) and it is eye blurry even for programmer
dbgLevel = 5     ## user of lib would change this "object" variable :)
##dbgLevel = 1   use -ddddd now
def dbg( level, strg ):
    if( dbgLevel >= level ) : 
        print( "<!--dbg%s: %s-->" % (level, strg) )

# -v add verbose output.  not sure if ever would need it
def vprint( level, strg ):
    if( verboseLevel >= level ) : 
        print( "%s" % strg )

# #NODELIST=$( sinfo --Node --long --format '%N %.8t' | awk '/idle/ {print $1}' | tail -2 )

"""
get ouptupt of 
sinfo --Node --long --format "%N %20P %.10t" | grep idle
which looks like
n0292.savio2 savio2             idle
n0297.savio2 savio2_knl         idle
n0298.savio2 savio2_1080ti      idle
"""
# XX (old) get ouptupt of sinfo -R -S ... 
# now just store output in a file  sinfoRSfile (global; future oop property)
# return is just exit code of running the sinfo cmd.
def generateSinfo() :
    global sinfoNfile
    dbg(5, "sinfoNfile is set to: %s" % sinfoNfile)
    cmd = 'sinfo --Node --long --format "%N %20P %.10t" | grep idle' + " > "  + sinfoNfile   # node first, one node per line :)
    #cmd = 'sinfo --Node --long --format "%N %20P %.10t"' + " > "  + sinfoNfile   
    command = cmd
    dbg(5, command)
    #sinfoRSout = subprocess.call(shlex.split(command))
    dbg(5, "sinfoNfile is set to: %s" % sinfoNfile)
    sinfoNout = os.system(command) # exit code only from mos.system(), result to to file of that var name
    dbg(5, "sinfoNfile is set to: %s" % sinfoNfile)
    #dbg(5, sinfoNfile ) # this reset sinfoNfile to 0 ?  cuz global? bug in dbg? ??
    return sinfoNout
    # return is just exit code of running the sinfo cmd.
#generateSinfo()-end

# buildSinfoList() return an array of lines
# each line is sanitized version of sinfo -RSE output line
# ie, each record become an array entry
def buildSinfoList():
#def buildSinfoList(infoRS=sinfoRSfile):
    # sinfoRSfile is currently global, i guess OOP would be very similar...
    # ++ consider changing to use fn arg for the file
    global sinfoNfile
    dbg(3, "buildSinfoList() about to open '%s'" % sinfoNfile )
    sinfoN = open( sinfoNfile,'r')
    #print( sinfoRS )
    #linelist = sinfoRS.split('\s')
    # basic cleansing/sanitizing done, just to avoid hacking
    # note that the debug still process original line
    # once stable and known work as desired, move the sanitizing earlier in the code
    # especially now user could be providing --nodelist or --sfile 
    sinfoList = [ ] 
    #XXfor line in sinfoRS :
    for line in sinfoN :
        dbg(4, "processing '%s'" % line.rstrip() )
        #currentLine = re.search( '([\S]+[\s]+)*', line.rstrip())   # truncate long lines :(  still match empty line :(
        currentLine = re.search( '^$', line )   # ie blank line
        if( currentLine ) :
            dbg(5, "skipping blank line" )
        else :
            # sinfoList.append( line.rstrip() )  # unsanitized, work.
            currentLine =  re.sub( '[;$`#\&\\\]', '_', line ).rstrip()   # sanitized
            # sanitization/cleansing replaces ; $ ` # &  \ with underscore
            # () still allowed.  but since $ not allowed, won't have 4()
            # * ' " are allowd.  not thinking of problem with these at this point
            sinfoList.append( currentLine )  # sanitized, replaces ; & with underscore
            #sinfoList.append( re.sub( r':;\&\*', r'_', line.rstrip() ) )  # sanitized, replaces ; & with underscore
            dbg(5, "adding...: '%s' to   sinfoList" % currentLine )
    #print( sinfoList )
    return sinfoList 
# buildSinfoList()-end


# Input: array list of lines with output of sinfo -R -S ...
# OUTPUT: array list of nodes (maybe empty)
# this was first coded up for offline development with saved sinfo ... output
# but useful for new user to call it, in case they want to dry run the script
# in non production environment :)
def sinfoList2nodeList( sinfoList ):
    #--linenum = 0 
    #--item = 0
    nodeList = [ ] 
    for line in sinfoList :
        nodeList.append( getNodeList( line ) )
    return nodeList
# sinfoList2nodeList()-end


# Input: single line of output of sinfo -R -S ...
# OUTPUT: array list of nodes (maybe empty)
# for now return a list of nodes needing ping/ssh info
## don't like this now.  very specific to our node naming convention of n0000.CLUSTER
## should just expect nodename from column 1 or some such
## TODO.  ie, relax it needing \d\d\d\d ... 
## do expect a cleansed file :)
#### i typically return only one node, and probably indeed do only so now
#### some sinfo -some-args return more than one node per line, maybe -RSE don't... 
#### this is working for bofhbot.py... 
def getNodeList( sinfoLine ) :
        line = sinfoLine
        nodeList = [ ]
        #node = re.search( '(n\d\d\d\d\.[\w]+)[,]*', str, re.U|re.I )  # only handle 1 node for now...

        #print( "%d :: %s " % (linenum, sinfoRS[linenum]) )
        lineItem = line.split()
        try :
            #str = lineItem[3]
            global nodeColumntIndex
            str = lineItem[nodeColumnIndex]  # nodeColumnIndex is global param (++better OOP sinfo.nodeColumnIndex() )
        except IndexError :
            str = "NADA"
        #print( "%d :: %s " % (linenum, lineItem[0]) )
        #dbgstr = "%d :: %s " % (linenum, str) 
        #dbg( 3, dbgstr )
        #if( str ~= 'n[\d\d\d\d]' ) : 
        #node = re.search( r'(n[\d\d\d\d])', str, re.U|re.I|re.VERBOSE )  
        node = re.search( '(n\d\d\d\d\.[\w]+)[,]*', str, re.U|re.I )  # only handle 1 node for now...
        if node : 
            #nodeList[item] = str
            dbgstr =  "===%s===" % node.group(1) 
            dbg(3, dbgstr)
            nodeList.append( node.group(1) )
        return nodeList
#getNodeList()-end


def checkLoad(node):
    command = "uptime | awk -F' ' '{ print substr($10,0,length($10)-1) }'"
    uptime = executeCommand(node, command)
    return uptime

def secondsToString(sec):
    sec = int(sec)
    if sec < 60:
        return "{}s".format(sec)
    minutes = sec // 60
    if minutes < 60:
        return "{}m".format(minutes)
    hours = minutes // 60
    if hours < 24:
        return "{}h".format(hours)
    days = hours // 24
    return "{}d".format(days) 

def checkUptime(node):
    command = "uptime -s"
    start_time = executeCommand(node, command)
    start_date = parser.parse(start_time) 
    return secondsToString(time.time() - start_date.timestamp())
    command = 'echo $(date +%s) - $(date --date="$(uptime -s)" +"%s") | bc'
    uptime = executeCommand(node, command)
    return secondsToString(int(uptime)) if uptime else "Error"

# other checks to add
# checkNhc()
# (see README)


def cleanUp() :
    if( dbgLevel == 0 ) :
        os.remove( sinfoRSfile ) 
    dbg(1, "sinfoRSfile left at: %s " % sinfoRSfile )
    vprint(1, "## Run 'reset' if terminal is messed up" )
    #os.system( "reset") # terminal maybe messed up due to bad ssh, but reset clears the screen :(
# cleanUp()-end

def make_color(a, b):
  return lambda s: '\033[{};{}m{}\033[0;0m'.format(a, b, s)
# Colors: https://stackoverflow.com/questions/37340049/how-do-i-print-colored-output-to-the-terminal-in-python
light_red = make_color(1, 31)
red = make_color(0, 31)
green = make_color(0, 32)
red_bg = make_color(1, 41)
green_bg = make_color(1, 42)
gray = make_color(1, 30)

# INPUT: data is ... ???
# OUTPUT:  stdout, decorated/improved output of sinfo -RSE
def processLine(data):
    node, line, color = data
    line = ' '.join(line.split(' ')[1:]) # Remove node name from beginning of line
    sshStatus = checkSsh(node)

    if color:
        ssh_color = green if sshStatus == 'up' else red
        sshStatusFormatted = ssh_color(sshStatus)
        node_color = green_bg if sshStatus == 'up' else red_bg
        nodeFormatted = node_color(node)
    else:
        sshStatusFormatted = sshStatus
        nodeFormatted = node
    skip = gray('(skip)') if color else '(skip)' 

    #++ these checks should be read from  a .cfg file
    checks = [
        ('scratch', lambda: checkMountUsage(node, "/global/scratch")),
        ('software', lambda: checkMountUsage(node, "/global/software")),
        ('tmp', lambda: checkMountUsage(node, "/tmp")),
        ('users', lambda: checkProcesses(node)),
        ('load', lambda: checkLoad(node)),
        ('uptime', lambda: checkUptime(node))
    ]

    ## added the try block, at least program no longer crash
    ## but time out error spill all over the screen. 
    ## furthermore, now only show ssh up, no other status :(   FIXME
    ## likely need to break out `results =` line to process error individually
    try:
        ##results = [ '{}:{:7}'.format(name, check() if sshStatus == 'up' else skip) for name, check in checks ]
        if sshStatus == 'up' :
            results = [ '{}:{:7}'.format(name, check() ) for name, check in checks ]
        else :
            #skip
            results = "" ## ie no output when ssh time out
    #except :
    except TypeError as e:
        results = "" ## ie no output when ssh time out
    #print("%-120s ## ssh:%4s scratch:%10s" % (line, sshStatus, scratchStatus, swStatus, tmpStatus))
    print("{:14} {:80} ## ssh: {:4} ".format(nodeFormatted, line, sshStatusFormatted) + ' '.join(results))
#processLine()-end

def print_stderr(s, color = True):
    # Colors: https://stackoverflow.com/questions/37340049/how-do-i-print-colored-output-to-the-terminal-in-python
    if color:
        s = light_red(s)
    sys.stderr.write(s + '\n')
    sys.stderr.flush()
# print_stderr()-end





#### main

def main(): 
    print("Power! Please!")
    global sinfoNfile
    generateSinfo()  
    sinfoList = buildSinfoList() # fn use "OOP/Global" file containing sinfo output

    # oh nick...
    # easier see old way https://github.com/tin6150/bofhbot/blob/8c111e4ef6c1cb5f38359ca7c95696a01046b618/bofhbot.py
    color=False
    # oh nick... nodes = [ (node, line, args.color) for line in sinfoList for node in getNodeList(line) ]

    nodeList = getNodeList(sinfoList)
    dbg(5, "nodes are: %s" % nodeList )

# main()-end

    
main()


#### vim modeline , but don't seems to fork on brc login node :(
#### vim: syntax=python  paste expandtab tabstop=4
