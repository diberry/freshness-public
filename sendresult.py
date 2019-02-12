import sendmail

fromEmail = 'apextest@microsoft.com'
toEmail = 'diberry@microsoft.com'
subject = "Freshness report!"
text = "This message was sent with Python's smtplib."
smtpServer = 'smtp.office365.com'
smtpPort = 587
authLogin = 'apextest@microsoft.com'
authPassword =  '#EDC4rfv%TGB6yhn'
file = 'freshness.csv'

sendmail.sendWithAttachment(fromEmail,toEmail,subject,text,file,smtpServer,smtpPort,authLogin,authPassword)
