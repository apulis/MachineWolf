import requests
import re
import hashlib
 
def md5_key(str):
    m = hashlib.md5()
    b = str.encode(encoding='utf-8')
    m.update(b)
    return m.hexdigest()
 
def get_id_tag(content, id_name):
    id_name = id_name.strip()
    patt_id_tag = """<[^>]*id=['"]?""" + id_name + """['" ][^>]*>"""
    id_tag = re.findall(patt_id_tag, content, re.DOTALL|re.IGNORECASE)
    if id_tag:
        id_tag = id_tag[0]
    return id_tag
 
def get_id_value(content, id_name):
    content = get_id_tag(content, id_name)
    id_name = id_name.strip()
    patt_id_tag = """value=['](.*)[']"""
    print("==================== verifyRand :"+patt_id_tag+"====================")
    value = re.findall(patt_id_tag, content)
    if value:
        value = value[0]
    return value
 
def get_count_of_bug_from_source(content):
    patt_count = "<tr data-id='(\d{3})'>"
    count = re.findall(patt_count, content)
    if count:
        count = count[0]
    return count

def get_pwd(password, str1):
    rand =get_id_value(str1, "verifyRand")
    print(rand)
    return md5_key(md5_key(password) + rand)
 
#登录的主方法
def login(baseurl_host,account,password, headers_base):
    baseurl = baseurl_host + "/user-login.html"
 
    #使用seesion登录，这样的好处是可以在接下来的访问中可以保留登录信息
    session = requests.session()
    #print(session.cookies)
    #requests 的session登录，以post方式，参数分别为url、headers、data
    content = session.get(baseurl,headers = headers_base)
    #print(session.cookies)
    #post需要的表单数据，类型为字典
    login_data = {
            'account':    account,
            'password':   get_pwd(password, content.text),
            'referer':    '/',
            'keepLogin':  1
    }
 
    content = session.post(baseurl, headers = headers_base,data = login_data)
    print("--------登录详情-----------------")
    print(content.text)
    #再次使用session以get去访问网页，一定要带上heades
    s = session.get("http://apulis.zentaopm.com/my/", headers = headers_base)
    #把爬下来的首页写到文本中
    with open('./chandao-login-info.txt', 'w') as f:
        f.write(s.text)
    return session
 
def getCountOfBugCreateByName(url_host,session, headers_base):
    url = url_host + "/bug-browse-7.html"
    content = session.post(url, headers = headers_base,data = 'fieldtitle=&fieldkeywords=&fieldsteps=&fieldassignedTo=&fieldresolvedBy=&fieldstatus=&fieldconfirmed=ZERO&fieldproduct=4&fieldplan=&fieldmodule=0&fieldproject=&fieldseverity=0&fieldpri=0&fieldtype=&fieldos=&fieldbrowser=&fieldresolution=&fieldactivatedCount=&fieldtoTask=&fieldtoStory=&fieldopenedBy=&fieldclosedBy=&fieldlastEditedBy=&fieldmailto=&fieldopenedBuild=&fieldresolvedBuild=&fieldopenedDate=&fieldassignedDate=&fieldresolvedDate=&fieldclosedDate=&fieldlastEditedDate=&fielddeadline=&fieldid=&fieldbugfrom=&fieldbugproject=&fieldcustomercompany=&fieldgcprojectno=&fieldgcprojectmanager=&fieldtimecount=&fieldbugresource=&andOr1=AND&field1=openedBy&operator1=%3D&value1=yangjian&andOr2=and&field2=id&operator2=%3D&value2=&andOr3=and&field3=keywords&operator3=include&value3=&groupAndOr=and&andOr4=AND&field4=steps&operator4=include&value4=&andOr5=and&field5=assignedTo&operator5=%3D&value5=&andOr6=and&field6=resolvedBy&operator6=%3D&value6=&module=bug&actionURL=%2Fzentaopms%2Fwww%2Fbug-browse-4-0-bySearch-myQueryID.html&groupItems=3&queryID=&formType=lite')
    print("**********************")
    # print(content.text)
 
    url = url_host + "/bug-browse-7-0-resolvedbyme-0--9-500-1.html"
    content = session.get(url, headers = headers_base)
    count = get_count_of_bug_from_source(content.text);
    print(count)
    return count

""" 
def logout(self):
    url = self.url + "user-logout.json"

    response = self.s.post(url, headers=self.headers, data=self.data)

    return response.status_code

def add_bug(self):

    url = self.url + "bug-create-1-0-moduleID=0.json"

    headers = {
        'Content-Type': "application/x-www-form-urlencoded; charset=utf-8"
    }

    t = time.asctime(time.localtime(time.time()))

    data = {
        "product": "1",  # int   所属产品 * 必填
        "openedBuild": "trunk",  # int | trunk   影响版本 * 必填
        "branch": "2",  # int    分支 / 平台
        "module": "",  # int    所属模块
        "project": "2",  # int   所属项目
        "assignedTo": "op042052",  # string 指派给
        "deadline": "",  # date 截止日期    日期格式：YY - mm - dd，如：2019 - 01 - 01
        "type": "codeerror",  # string   Bug类型   取值范围： | codeerror | interface | config | install | security | performance | standard | automation | designchange | newfeature | designdefect | trackthings | codeimprovement | others
        "os": "",  # string 操作系统 取值范围： | all | windows | win8 | win7 | vista | winxp | win2012 | win2008 | win2003 | win2000 | android | ios | wp8 | wp7 | symbian | linux | freebsd | osx | unix | others
        "browser": "",  # string    浏览器 取值范围： | all | ie | ie11 | ie10 | ie9 | ie8 | ie7 | ie6 | chrome | firefox | firefox4 | firefox3 | firefox2 | opera | oprea11 | oprea10 | opera9 | safari | maxthon | uc | other
        "color": "",  # string  颜色格式：  # RGB，如：#3da7f5
        "severity": "1",  # int  严重程度    取值范围：1 | 2 | 3 | 4
        "pri": "1",  # int   优先级 取值范围：0 | 1 | 2 | 3 | 4
        "mailto": "",  # string 抄送给 填写帐号，多个账号用','分隔。
        "keywords": "",  # string   关键词
        "title": t,  # string  Bug标题 * 必填
        "steps": "set bug link in here"  # string   重现步骤
    }

    response = self.s.post(url, headers=headers, data=data)

    print(response.content.decode('utf-8'))
"""
    
#程序从这里开始。
url_host = "http://apulis.zentaopm.com"
account = "xxxxxxxx"
password = "xxxxxxxx"
headers_base = {
'Referer':          'http://apulis.zentaopm.com/user-login.html',
'Accept-Language':  'en-US,en;q=0.9,zh-TW;q=0.8,zh;q=0.7',
'Origin':           'http://apulis.zentaopm.com',
'X-Requested-With': 'XMLHttpRequest',
'Content-Type':     'application/x-www-form-urlencoded; charset=UTF-8',
'Accept-Encoding':  'gzip, deflate',
'Accept':           'application/json, text/javascript, */*; q=0.01',
'User-Agent':       'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36'
}
#进行登录，将账户信息替换成你的用户名和密码即可
login_info = './login_info.txt'
session = login(url_host, account, password, headers_base)
count = getCountOfBugCreateByName(url_host, session, headers_base)
# print("共 " + count + "条记录")
#print(md5_key(account))
#print(account + get_id_value("<input type='hidden' name='verifyRand' id='verifyRand' value='981871570'  />", "verifyRand"))
#print(md5_key(md5_key(password) + "944069017"))
