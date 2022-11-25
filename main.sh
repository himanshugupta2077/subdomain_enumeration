#!/usr/bin/bash

domain=$1

subdomain_path=$domain

if [ ! -d "$domain" ];then
	mkdir $domain
fi

if [ ! -d "$subdomain_path" ];then
	mkdir $subdomain_path
fi

echo -e "[+] Checking in subscraper"
subscraper -r $subdomain_path/subscraper_output1 $domain > /dev/null && cat $subdomain_path/subscraper_output1 > $subdomain_path/found.txt

echo -e "[+] Checking again in subscraper"
subscraper -r $subdomain_path/subscraper_output2 $domain > /dev/null && cat $subdomain_path/subscraper_output2 >> $subdomain_path/found.txt

echo -e "\n[+] Checking in subfinder"
subfinder -d $domain  > /dev/null 2>&1 > $subdomain_path/subfinder_output1 && cat $subdomain_path/subfinder_output1 >> $subdomain_path/found.txt

echo -e "[+] Checking again in subfinder"
subfinder -d $domain  > /dev/null 2>&1 > $subdomain_path/subfinder_output2 && cat $subdomain_path/subfinder_output2 >> $subdomain_path/found.txt

echo -e "\n[+] Checking in asset	er"
assetfinder $domain | grep $domain > $subdomain_path/assetfinder_output && cat $subdomain_path/assetfinder_output >> $subdomain_path/found.txt

cat $subdomain_path/found.txt | sort | sort -u > $subdomain_path/sorted.txt
echo -e "\n[+] Total Subdomain Count: "
cat $subdomain_path/sorted.txt | wc -l

echo -e "\n[+] Total Alive Subdomain Count:"
cat $subdomain_path/sorted.txt | httprobe > $subdomain_path/alive.txt
cat $subdomain_path/alive.txt | sort | sort -u | wc -l

echo -e "\n[+] Subdomain Enumeration Completed."