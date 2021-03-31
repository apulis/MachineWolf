# coding=UTF-8
""" FAKE_USER
# INFO:    创建虚拟测试用户信息
# VERSION: 2.0
# EDITOR:  thomas
# TIMER:   2021-03-09
"""

import random
import string
from faker import Faker
from faker.providers import BaseProvider
import hashlib


Faker.seed(2025)
location = ["en-US", "zh_CN"]
PASSWORD_DEFAULT = "123456"

class SystemRole(BaseProvider):
    # create new provider class for apulis ai platform user roles
    # {"System Admin":1, "User":2, "Annotation Person":3 }
    Role = [1,2,3 ]

    def role(self):
        random.shuffle(self.Role)
        # return self.Role[:2] # 随机返回2个role
        return [1,2]

class ChinesePhone(BaseProvider):
    # create new provider class for chinese mainland cellphone numbers 
    PhoneChinaPrefix = [
    '130', '131', '132', '133', '134', '135', '136', '137', '138', '139',
    '145', '147', '149', '150', '151', '152', '153', '155', '156', '157',
    '158', '159', '165', '171', '172', '173', '174', '175', '176', '177',
    '178', '180', '181', '182', '183', '184', '185', '186', '187', '188',
    '189', '191'
    ]
    def MainlandCellPhone(self):
        
        return ''.join([self.PhoneChinaPrefix[random.randint(0, len(self.PhoneChinaPrefix) - 1)],''.join(random.sample(string.digits, 8))])


def security_passwd(passwd=PASSWORD_DEFAULT):
    Md5Passwd = hashlib.md5()
    Md5Passwd.update(passwd.encode("utf-8"))
    SecurityPasswd = (Md5Passwd.hexdigest()).lower()
    return SecurityPasswd

def new_user():
    DataFactory = Faker(location=["en-US", "zh_CN"])
    Nickname = DataFactory.name()
    DataFactory = Faker(location=["en-US"])
    Username = DataFactory.first_name_nonbinary()
    if len(Username) <6:
        Username = Username + "_" + ''.join(random.sample(string.ascii_letters + string.digits, 6)) 
    Firstname = DataFactory.first_name()
    Lastname = DataFactory.last_name()
    Passwd = PASSWORD_DEFAULT
    SecurityPasswd = security_passwd()
    DataFactory.add_provider(ChinesePhone)
    Phone = DataFactory.MainlandCellPhone()
    Email = DataFactory.ascii_free_email()
    Description = DataFactory.job()
    DataFactory.add_provider(SystemRole)
    Role = DataFactory.role()      
    return {"userMessage":[{"nickName":Nickname,
                            "userName":Username,
                            "password":SecurityPasswd,
                            "phone":Phone,
                            "email":Email,
                            "note":Description}],
            "userRole":Role}

def new_group():
    DataFactory = Faker(location=["en-US", "zh_CN"])
    Groupnote = DataFactory.job()
    DataFactory = Faker(location=["en-US"])
    Groupname = DataFactory.first_name_nonbinary()
    DataFactory.add_provider(SystemRole)
    Role = DataFactory.role()  
    return {"name":Groupname,
            "note":Groupnote,
            "role":Role
            }

def new_role():
    DataFactory = Faker(location=["en-US", "zh_CN"])
    Rolenote = DataFactory.job()
    DataFactory = Faker(location=["en-US"])
    Rolename = DataFactory.first_name_nonbinary()
    DataFactory.add_provider(SystemRole)
    Role = DataFactory.role()  
    return {"name":Rolename,
            "note":Rolenote,
            "permissions":Role   
            }

def new_project():
    

if __name__ == "__main__":
    print(new_user())
    # print(new_group())
    # print(new_role())
    pass