import smtplib
from email.message import EmailMessage

user = 'xxxxxxxxx@xxxxxxxx.com'
password = 'xxxxxxxxxxxx'
smtpsrv = "smtp.office365.com"
smtpserver = smtplib.SMTP(smtpsrv,587)

msg = EmailMessage()

msg['Subject'] = 'Email Testing with Python'
msg['From'] = 'xxxxxxxxx@xxxxxxxxx.com'
msg['To'] = 'xxxxxxxx@163.com'


smtpserver.ehlo()
smtpserver.starttls()
smtpserver.login(user, password)
smtpserver.send_message (msg)
smtpserver.close()


##
'''
参考链接;
https://docs.microsoft.com/zh-cn/Exchange/mail-flow-best-practices/how-to-set-up-a-multifunction-device-or-application-to-send-email-using-microsoft-365-or-office-365?redirectSourcePath=%252fen-us%252farticle%252fHow-to-set-up-a-multifunction-device-or-application-to-send-email-using-Office-365-69f58e99-c550-4274-ad18-c805d654b4c4
https://pythoncircle.com/post/36/how-to-send-email-from-python-and-django-using-office-365/
https://medium.com/@neonforge/how-to-send-emails-with-attachments-with-python-by-using-microsoft-outlook-or-office365-smtp-b20405c9e63a
'''