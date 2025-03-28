# remap Home/End key to be like windows.

# need to relogin to be effective... 

# safe to rerun multiple times


# I covered the home key, but still hit the end key, which seems to be the most annoying key that navigate me far away.
##     	hmm… learn that cmd+up is home… no, does NOT always help, cuz maybe in middle of a doc.


# so that's the one I really want to disable.

# but remapping it… to be like windows…. 
# might make me bind to specific mac… but then it is laptop or my computer, so can do this all my putters?

# https://discussions.apple.com/thread/251108215?answerId=252138948022&sortBy=rank#252138948022



mkdir -p $HOME/Library/KeyBindings
echo '{
/* Remap Home / End keys to be correct */
"\UF729" = "moveToBeginningOfLine:"; /* Home */
"\UF72B" = "moveToEndOfLine:"; /* End */
"$\UF729" = "moveToBeginningOfLineAndModifySelection:"; /* Shift + Home */
"$\UF72B" = "moveToEndOfLineAndModifySelection:"; /* Shift + End */
"^\UF729" = "moveToBeginningOfDocument:"; /* Ctrl + Home */
"^\UF72B" = "moveToEndOfDocument:"; /* Ctrl + End */
"$^\UF729" = "moveToBeginningOfDocumentAndModifySelection:"; /* Shift + Ctrl + Home */
"$^\UF72B" = "moveToEndOfDocumentAndModifySelection:"; /* Shift + Ctrl + End */
}' > $HOME/Library/KeyBindings/DefaultKeyBinding.dict


