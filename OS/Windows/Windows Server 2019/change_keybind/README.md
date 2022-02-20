# キーバインド変更
## 
`PSReadLine`モジュールをインポートする。
```ps
Import-Module PSReadLine -Scope CurrentUser
```
`$PROFILE`(C:\Users\\<ユーザ名>\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1)を作成する。  
途中のディレクトリがない場合は作成すること。
```ps
New-Item $PROFILE
```
`$PROFILE`に以下を書き込む。
```
Set-PSReadLineKeyHandler -Key "Ctrl+d" -Function DeleteChar
Set-PSReadLineKeyHandler -Key "Ctrl+w" -Function BackwardKillWord
Set-PSReadLineKeyHandler -Key "Ctrl+u" -Function BackwardDeleteLine
Set-PSReadLineKeyHandler -Key "Ctrl+k" -Function ForwardDeleteLine
Set-PSReadLineKeyHandler -Key "Ctrl+a" -Function BeginningOfLine
Set-PSReadLineKeyHandler -Key "Ctrl+e" -Function EndOfLine
Set-PSReadLineKeyHandler -Key "Ctrl+f" -Function ForwardChar
Set-PSReadLineKeyHandler -Key "Ctrl+b" -Function BackwardChar
Set-PSReadLineKeyHandler -Key "Alt+f" -Function NextWord
Set-PSReadLineKeyHandler -Key "Alt+b" -Function BackwardWord
Set-PSReadLineKeyHandler -Key "Ctrl+p" -Function PreviousHistory
Set-PSReadLineKeyHandler -Key "Ctrl+n" -Function NextHistory
```
最後に`$PROFILE`を再読み込み。
```ps
& $PROFILE
```
キーバインドの確認は以下のコマンドでする。
```ps
Get-PSReadLineKeyHandlerで
```
