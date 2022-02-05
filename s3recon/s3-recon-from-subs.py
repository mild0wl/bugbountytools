import requests
import sys


with open(sys.argv[1]) as sf:
    subs = sf.readlines()
    for sub in subs:
        sub = sub.strip()
        url = f"https://s3.amazonaws.com/{sub}"
        resp = requests.get(url)
        if resp.status_code == 200:
            print(sub)
