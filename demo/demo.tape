# vhs demo.tape  ->  bluepencil-demo.mp4
Output bluepencil-demo.mp4
Set Shell bash
Set FontSize 30
Set Width 1920
Set Height 1080
Set Theme "Catppuccin Latte"
Set Padding 40
Set TypingSpeed 35ms

Hide
Type "export PATH=$PWD:$PATH; rm -f result.txt; clear"
Enter
Show

Type "# A recruiting agent drafted this. Nobody should send it as is."
Sleep 1.5s
Enter
Type "cat draft-email.txt"
Enter
Sleep 9s

Type "clear"
Enter
Type "# Hand it to bluepencil, the copy desk."
Sleep 1.5s
Enter
Type "bluepencil draft-email.txt"
Enter
Sleep 3s
Hide
Sleep 120s
Show
Sleep 2s

Type "clear"
Enter
Type "# The finished text. Nothing invented: gaps stay marked."
Enter
Type "sed '/^---/q' result.txt"
Enter
Sleep 11s

Type "clear"
Enter
Type "# Every change, with a reason."
Enter
Type "sed -n '/^---/,$p' result.txt | tail -n +2 | tr -d '*'"
Enter
Sleep 14s
