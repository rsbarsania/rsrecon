#!/bin/bash

dom=$1

Sdom(){
/root/go/bin/assetfinder $dom | tee af.tmp
/root/go/bin/subfinder -d $dom -silent | tee sf.tmp
python3 /usr/lib/python3/dist-packages/sublist3r.py -d $dom -t 20 -o slist.tmp -n
/opt/sd-goo/sd-goo.sh $dom | sort -u | tee sdgo.tmp
cat af.tmp sf.tmp slist.tmp sdgo.tmp | sort -u > subdomain.txt
}

Hpx(){
cat subdomain.txt | /root/go/bin/httpx -silent | tee httpx.txt
}

Dnx(){
cat subdomain.txt | /root/go/bin/dnsx -silent > dnsx.tmp
cat httpx.txt | sed -E 's/^\s*.*:\/\///g' > hx.tmp
awk 'FNR==NR {a[$0]++; next} !($0 in a)' hx.tmp dnsx.tmp | tee dnsx.txt
}

Sshot(){
cat httpx.txt | /root/go/bin/aquatone
}


Blc(){
while IFS= read -r dtar; do
blc --exclude linkedin.com --exclude youtube.com $dtar | grep -vi "$tar" | grep -i 'BROKEN'
done < httpx.txt
}


Dsearch(){
while IFS= read -r dtar; do
dirsearch -u $dtar/ -x 405-599
done < httpx.txt
}

Rclean(){
rm -rf *.tmp
}

echo -e "\e[34m[+] Enumerating Subdomains\e[0m"
Sdom
echo -e "\e[35m[+] Checking For Alive Hosts\e[0m"
Hpx
echo -e "\e[36m[+] CHecking From DNS Record\e[0m"
Dnx
echo -e "\e[31m[+] Taking Screenshots\e[0m"
Sshot
echo -e "\e[32m[+] Checking Broken Links\e[0m"
Blc
echo -e "\e[33m[+] Executing DirSearch\e[0m"
Dsearch
Rclean
