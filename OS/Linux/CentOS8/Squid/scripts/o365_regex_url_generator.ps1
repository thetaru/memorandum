# JSONファイルから抽出したURLを出力するファイルのパスを指定
$DATE_FORMAT=Get-Date -Format "yyyyMMddhhmmss"
$OUTPUT_FILE=".\m365_url_$DATE_FORMAT.log"

# Office 365 URL および IP アドレス範囲
# https://docs.microsoft.com/ja-jp/microsoft-365/enterprise/urls-and-ip-address-ranges?view=o365-worldwide
$URL="https://endpoints.office.com/endpoints/worldwide?clientrequestid=b10c5ed1-bad1-445f-b386-b919946339a7"


Function generate_regex_url($url) {
  # STEP1: 文頭(http://|https://)削除
  $url = $url -replace "^(http|https):\/\/",""
  # STEP2: ディレクトリ部削除
  $url = $url -replace "^([^\/]*)\/.*","`$1"
  # STEP3: .を\.に置換
  $url = $url -replace "\.","\."
  # STEP4: 不要な半角・全角スペースとタブを削除
  $url = $url -replace "[ 　\t]",""
  # STEP5: 文頭が*出ない場合、^を追加
  $url = $url -replace "^([^\*].*)","^`$1"
  # STEP6: 文頭の*を削除
  $url = $url -replace "^\*(.*)","`$1"
  # STEP7: *を.*に置換
  $url = $url -replace "\*",".*"
  # STEP8: 末尾に$を追加
  $url = $url -replace "^(.*)$","`$1`$"
  $url
}

try {
  $json = (curl "$URL" -ErrorAction Stop).Content
  $obj =ConvertFrom-Json $json
  $o365_obj = $obj | Where-Object { $_.serviceAreaDisplayName -eq "Microsoft 365 Common and Office Online" }
  $urls = $o365_obj | ?{$_.urls -ne $null}
  $urls = ($urls).urls | Sort-Object -Unique 
  for ($i = 0; $i -lt $urls.Count; $i++) {
    generate_regex_url $urls[$i] >> "$OUTPUT_FILE"
  }
} catch {
  Write-Output ('ERROR: ' + $_.Exception.Message) >> ./Error.log
}
