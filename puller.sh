#!/usr/bin/env sh

page_number="${1}"


generate_api_key() {
    api_key_in_header=$(curl --verbose -X POST 'https://www.korunka.eu/rest/korunka/v1/init-web?originalReferrer=' \
         -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0' \
         -H 'Accept: application/json' \
         -H 'Accept-Language: en-US,en;q=0.5' \
         -H 'Accept-Encoding: gzip, deflate, br' \
         -H 'Referer: https://www.korunka.eu/archiv-vysledku' \
         -H 'application-type: WEB_DESKTOP' \
         -H 'content-type: application/json' \
         -H 'Origin: https://www.korunka.eu' \
         -H 'DNT: 1' -H 'Connection: keep-alive' \
         -H 'Sec-Fetch-Dest: empty' \
         -H 'Sec-Fetch-Mode: cors' \
         -H 'Sec-Fetch-Site: same-origin' \
         --data-raw '{"restartSession":false,"parameters":[""],"platform":"WEB","consents":null}' 2>&1|grep APISID)
    
    api_key_header="${api_key_in_header#*:}"
    api_key=${api_key_header%%;*}
    
    printf '%s' $api_key
}

echo "Getting API key"
new_api_key=$(generate_api_key)

file_name="korunka_data_${page_number:-1}.json.gz"


# Get data
echo "Getting data..."
curl "https://www.korunka.eu/rest/msc/v1/statistics/draws?from=1997-01-01&size=2000&to=2100-01-01&page=${page_number:-1}" \
    -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0' \
    -H 'Accept: application/json' \
    -H 'Accept-Language: en-US,en;q=0.5' \
    -H 'Accept-Encoding: gzip, deflate, br' \
    -H 'Referer: https://www.korunka.eu/archiv-vysledku' \
    -H 'application-type: WEB_DESKTOP' \
    -H 'content-type: application/json' \
    -H 'DNT: 1' \
    -H 'Connection: keep-alive' \
    -H "Cookie: $new_api_key; " \
    -H 'Sec-Fetch-Dest: empty' \
    -H 'Sec-Fetch-Mode: cors' \
    -H 'Sec-Fetch-Site: same-origin' \
    --output $file_name
