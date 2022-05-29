# Cloudflare Accessを使ったSSHトンネルの作成
## ■ 前提条件
- 踏み台サーバのOSはubuntuとする
- Cloudflareのアカウントが作成済みであること
- Cloudflareにドメインを登録していること

## ■ Cloudflare Accessの設定

## ■ Cloudflaredの設定
以下、踏み台サーバで作業する。
### cloudflaredのインストール
[Cloudflare Docs - installation](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/installation#linux)より抜粋した。
```sh
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
```

### Cloudflare Tunnelの作成
[Cloudflare Docs - Set up your first tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide/)より抜粋した。
```sh
cloudflared tunnel login
```
```sh
# NAMEという名前のトンネルを作成
cloudflared tunnel create <NAME>
```
[Cloudflare Docs - Ingress rules](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/configuration/local-management/ingress/)を参照した。
```yaml
tunnel: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
credentials-file: /root/.cloudflared/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX.json

ingress:
  - hostname: XXX.example.com
    service: http://localhost:80
  - hostname: YYY.example.com
    service: ssh://localhost:22
  - service: http_status:404
```
```sh
# トンネルの実行
cloudflared tunnel run <UUID or NAME>
```
```sh
# トンネルの情報を取得
cloudflared tunnel info <UUID or NAME>
```
[Cloudflare Docs - Run as a service on Linux](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/run-tunnel/as-a-service/linux/)より抜粋した。
```sh
cloudflared service install
```
