# "Memory" layout
#
# Variable designator
#
# Variables
# {varname=value}
# {blockname==block_start,block_end} 
# 
# Processed text
#
# Examples
# #$#{var1=this is var one}{block1==begin,end}#currently evaluated text SED_COLON var1 block1(var1)#
# #eval #{var1=this is var one}{block1==begin,end}#currently evaluated text#

s # SED_HASH g
s { SED_OPEN_CURLY g
s } SED_CLOSED_CURLY g
s , SED_COMMA g
s : SED_COLON g
s = SED_EQUALS g
s \$ SED_DOLLAR g
s \\ SED_BACKSLASH g
s / SED_SLASH g
s | SED_PIPE g
#s \n SED_NEWLINE g

1{
# Init memory (only on first line)
s@\(.*\)@#SED_DOLLAR#{SED_PREPROC_VER=1.0}#\1#@
h
b eval
}

# Memory is already initialized. Process current line normally
G
s/\n//g
s \([^#]*\)#\(.*\)#$ #\2\1# g

:eval
# Redeclare evaluator symbol
s/^#\([^#]*\)#\([^#]*\)#\([^#]*\)\1SED_EVALUATOR_SYMBOL[ \t]*SED_EQUALS \?\([^#]*\)#/#\4#\2#\3#/

# Variable redeclaration. Change the value of a var if it is assigned a new value
s/^#\([^#]*\)#\([^#]*\){\([^#{}=]\)=\([^#{}=]\)}#\([^#]*\)\1\3[ \t]*SED_EQUALS \?\([^#]*\)#/#\1#\2{\3=\6}#\5#/

# Variable declaration
s/^#\([^#]*\)#\([^#]*\)#\([^#]*\)\1\([^# \t]\+\)[ \t]*SED_EQUALS \?\([^#]*\)#/#\1#\2{\4=\5}#\3#/

# Variable substitution/evaluation/expansion
s@^#\([^#]*\)#\([^#]*\){\([^={}#]*\)=\([^={}#]*\)}\([^#]*\)#\([^#]*\)\1\3\([^#]*\)#@#\1#\2{\3=\4}\5#\6\4\7#@

# Re-evaluate, because new variables might be expandable
t eval

# Cleanup
h # Create a copy of the internal state
# Clean up the current buffer into the evaluated text
s ^#\([^#]*\)#\([^#]*\)#\([^#]*\)# \3 
x
# Clean up memory state (remove current line from it)
s ^#\([^#]*\)#\([^#]*\)#\([^#]*\)# #\1#\2##  
x

# Resubstitute special characters
s SED_HASH # g
s SED_OPEN_CURLY { g
s SED_CLOSED_CURLY } g
s SED_COMMA , g
s SED_COLON : g
s SED_EQUALS = g
s SED_DOLLAR \$ g
s SED_BACKSLASH \\ g
s SED_SLASH / g
s SED_PIPE | 6
s SED_NEWLINE \n g
p
