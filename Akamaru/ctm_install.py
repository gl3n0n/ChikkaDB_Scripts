import sys 
import requests
from os import path
from bs4 import BeautifulSoup



class SessionGoogle:
    def __init__(self, url_login, url_auth, login, pwd):
        self.ses = requests.session()
        login_html = self.ses.get(url_login)
        soup_login = BeautifulSoup(login_html.content).find('form').find_all('input')
        dico = {}
        for u in soup_login:
            if u.has_attr('value'):
                dico[u['name']] = u['value']
        # override the inputs with out login and pwd:
        dico['Email'] = login
        dico['Passwd'] = pwd
        self.ses.post(url_auth, data=dico)
    

    def get(self, URL):
        
	content = self.ses.get(URL)
	filename = os.path.dirname(os.path.realpath(__file__)) + os.path.basename(sys.argv[3])
	f =  open(filename, 'wb')
	for chunk in content.iter_content(chunk_size=1024): 
            	if chunk:
                	f.write(chunk)
                	f.flush()
	f.close()

    def logout(self):
        content = self.ses.get("http://www.google.com/accounts/Logout?continue=https://play.google.com/apps/publish")

url_login = "https://accounts.google.com/ServiceLogin?service=androiddeveloper"
url_auth = "https://accounts.google.com/ServiceLoginAuth"
session = SessionGoogle(url_login, url_auth, "pl4ystatsd0wnload3r", "GKUwIX5XRhFqb8qbykZn")
download_link = "https://play.google.com/apps/publish/statistics/download?package=com.chikka.gero&sd=" + sys.argv[1] + "&ed="+ sys.argv[2]+ "&dim=overall,os_version,device,country,language,app_version,carrier,device_class,crash_details,anr_details&met=current_device_installs,daily_device_installs,daily_device_uninstalls,daily_device_upgrades,current_user_installs,total_user_installs,daily_user_installs,daily_user_uninstalls,daily_avg_rating,total_avg_rating,daily_crashes,daily_anrs&dev_acc=06792924688951822153"
session.get(download_link)
session.logout()

