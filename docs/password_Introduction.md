# 密码策略规则

| 属性项 | 属性说明 | 备注 |
| :---: | :---: | :---: |
| minPoints | 密码的质量点 | 配置值为 `整数`，包含几种字符 |
| minUpper | 密码的大写字符 | 配置为 `整数`， 包含几个大写字符 |
| minLower | 密码的小写字符 | 配置为 `整数`， 包含几个小写字符 |
| minDigit | 密码的数字 | 配置为 `整数`， 包含几个数字 |
| minPunct | 密码的标点符号 | 配置为 `整数`，包含几个标点符号 |

**配置实例**

```bash
cat /etc/openldap/check_password.conf
minPoints 2
useCracklib 0
minUpper 2
minLower 4
minDigit 1
minPunct 1
```