import smtplib
import mimetypes
from email.mime.multipart import MIMEMultipart
from email import encoders
from email.message import Message
from email.mime.audio import MIMEAudio
from email.mime.base import MIMEBase
from email.mime.image import MIMEImage
from email.mime.text import MIMEText


def send(fromEmail,toEmail,subject,text,smtpServer,smtpPort,authLogin,authPassword):
    try:
        message = 'Subject: {}\n\n{}'.format(subject, text)

        print ("sendmail")
        mailserver = smtplib.SMTP(smtpServer,smtpPort)
        mailserver.set_debuglevel(1)
        mailserver.ehlo()
        mailserver.starttls()
        mailserver.login(authLogin, authPassword)
        mailserver.sendmail(fromEmail,[toEmail],message)
        mailserver.quit() 
    except Error:
        print (Error)

def sendWithAttachment(fromEmail,toEmail,subject,text,fileToSend,smtpServer,smtpPort,authLogin,authPassword):
    try:
        msg = MIMEMultipart()
        msg["From"] = fromEmail
        msg["To"] = toEmail
        msg["Subject"] = subject
        msg["Text"] = "sending attachement"
        msg.attach(MIMEText(text, 'plain'))

        ctype, encoding = mimetypes.guess_type(fileToSend)
        if ctype is None or encoding is not None:
            ctype = "application/octet-stream"

        maintype, subtype = ctype.split("/", 1)

        if maintype == "text":
            fp = open(fileToSend)
            # Note: we should handle calculating the charset
            attachment = MIMEText(fp.read(), _subtype=subtype)
            fp.close()
        elif maintype == "image":
            fp = open(fileToSend, "rb")
            attachment = MIMEImage(fp.read(), _subtype=subtype)
            fp.close()
        elif maintype == "audio":
            fp = open(fileToSend, "rb")
            attachment = MIMEAudio(fp.read(), _subtype=subtype)
            fp.close()
        else:
            fp = open(fileToSend, "rb")
            attachment = MIMEBase(maintype, subtype)
            attachment.set_payload(fp.read())
            fp.close()
            encoders.encode_base64(attachment)
        attachment.add_header("Content-Disposition", "attachment", filename=fileToSend)
        msg.attach(attachment)

        print ("sendmail")
        mailserver = smtplib.SMTP(smtpServer,smtpPort)
        mailserver.set_debuglevel(1)
        mailserver.ehlo()
        mailserver.starttls()
        mailserver.login(authLogin, authPassword)

        print ("send")
        mailserver.sendmail(fromEmail,[toEmail], msg.as_string())

        mailserver.quit()
    except Error:
        print (Error) 