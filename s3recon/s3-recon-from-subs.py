import requests
import sys

# or we can use 
# httpx -l s3-urls.txt -mc 200 -silent -o s3-alive.txt -t 200
# s3-url eg: https://s3.amazonaws.com/subdomain/
with open(sys.argv[1]) as sf:
    subs = sf.readlines()
    for sub in subs:
        sub = sub.strip()
        url = f"https://s3.amazonaws.com/{sub}"
        resp = requests.get(url)
        if resp.status_code == 200:
            print(sub)
