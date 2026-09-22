# vhs demo.tape  ->  bluepencil-demo.mp4
Output bluepencil-demo.mp4
Set Shell bash
Set FontSize 18
Set Width 1600
Set Height 1000
Set Theme "Catppuccin Latte"
Set Padding 30
Set TypingSpeed 40ms

Hide
Type "export PATH=$PWD:$PATH; clear"
Enter
Show

Type "# A recruiting agent drafted this reply to a candidate. Nobody should send it as is."
Sleep 1.5s
Enter
Type "cat draft-email.txt"
Enter
Sleep 8s

Type "clear"
Enter
Type "# Hand it to bluepencil, the copy desk."
Sleep 1.5s
Enter
Type "bluepencil draft-email.txt"
Enter
Wait+Screen@170s /Facts:|Changes/
Sleep 12s
