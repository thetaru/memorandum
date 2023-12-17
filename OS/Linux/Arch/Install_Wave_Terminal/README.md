# Wave Terminalのインストール
## Wave Terminalのダウンロード
`https://www.waveterm.dev/download`よりダウンロードする。
```sh
# 解凍する
unzip waveterminal-linux-x64-v0.5.1.zip -d /usr/local/Wave
```

## ランチャーにWave Terminalを登録
```sh
vim ~/.local/share/applications/wave.desktop
```
```ini
[Desktop Entry]
Version=0.5.1
Type=Application
Name=Wave Terminal
Icon=/usr/local/Wave/Wave/resources/app/public/logos/wave-logo.png
Exec="/usr/local/Wave/Wave"
Comment=Wave Terminal
Categories=Development;
Terminal=false
StartupWMClass=wave-terminal
```
