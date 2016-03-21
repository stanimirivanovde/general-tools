# check-public-ip
Checks the public IP of your computer/server and sends you an e-mail if it has changed. You'll need to have ssmtp installed and configured correctly. A sample ssmtp.conf file is included for Yahoo e-mails. You can place this in your crontab file and let it run every 5 minutes. Pipe the output to a log file if you want. It should take ~ 100MB a year worth of log file space.

