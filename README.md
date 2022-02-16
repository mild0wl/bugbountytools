# bugbountytools
my bug hunitng tools


## recon method

```bash
# subs
subfinder -d sub.com -silent -o subfinder.txt
amass enum -active -brute -d sub.com -o amass-active.txt
echo "sub.com" | assetfinder --subs-only | tee -a assetfinder.txt

cat subfinder.txt amass-active.txt assetfinder.txt | sort -u | tee -a subs.txt

for i in `seq 1 3`; do subfinder -dL subs.txt -silent | anew subs.txt; amass enum -active -brute -d sub.com | anew subs.txt;done

cat subs.txt | dnsgen - | massdns -r ~/resolvers.txt -t A -o S -w massdns.txt --flush 2>/dev/null

# domains
cat massdns.txt | cut -d " " -f1 | sort -u | tee -a final.subs.dnsgen.txt

cat final.subs.dnsgen.txt subs.txt | sort -u | tee final.txt

# IPs
cat massdns.txt | cut -d " " -f3 | grep -e "\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}$" | sort -u | tee -a ips.txt

# CNAMEs
cat massdns.txt | cut -d " " -f3 | grep -e "\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}$" -v | sort -u | tee -a cnames.txt

# aquatone
cat final.txt | aquatone -scan-timeout 3000 -threads 10 -chrome-path ~/tools/chromium-latest-linux/latest/chrome -out aquatone -ports xlarge

# naabu
## Subdomains - full port scan
cat final.txt | naabu -silent -p 1-65535 -o portscan.txt -c 50 

# for ips - full port scan
cat ips.txt | naabu -silent -p 1-65535 -o ips_portscan.txt -c 50

mkdir nmap_data
mkdir -p nmap_data/subs nmap_data/ips

## Subs Service scan
portsfile=portscan.txt

cat $portsfile | cut -d ":" -f1 | sort -u | while read sub;
do
	ports=$(grep $sub $portsfile | cut -d ":" -f2 | tr "\n" "," | sed "s/,$//")
	nmap $sub -Pn -T4 -sV -sC -oN nmap_data/subs/$sub.txt -p $ports
done 

## IPS service scan
portsfile=ips_portscan.txt

cat $portsfile | cut -d ":" -f1 | sort -u | while read ip;
do
	ports=$(grep $ip $portsfile | cut -d ":" -f2 | tr "\n" "," | sed "s/,$//")
	nmap $ip -Pn -T4 -sV -sC -oN nmap_data/ips/$ip.txt -p $ports
done 

```
