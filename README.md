[![Publish GitHub Package](https://github.com/mulesoft-consulting/jwt-dw-module/actions/workflows/master.yaml/badge.svg)](https://github.com/mulesoft-consulting/jwt-dw-module/actions/workflows/master.yaml) [![Unit Test Module](https://github.com/mulesoft-consulting/jwt-dw-module/actions/workflows/develop.yml/badge.svg)](https://github.com/mulesoft-consulting/jwt-dw-module/actions/workflows/develop.yml)

# DataWeave JWT Module

This module provides functionality to create signed JSON Web Tokens. The following formats are currently support:

* HS256
* HS384
* HS512
* RS256
* RS384
* RS512

RSA private keys must be in PKCS#1 or PKCS#8 format.

Example RSA usage:

```dataweave
%dw 2.0
output application/java
import jwt::RSA
---
{
	token: RSA::JWT(
		{
			iss: p('google.clientEmail'),
			aud: 'https://oauth2.googleapis.com/token',
			scope: 'https://www.googleapis.com/auth/drive.readonly',
			iat: now() as Number { unit: 'seconds' },
			exp: (now() + |PT3600S|) as Number { unit: 'seconds' }
		},
		p('google.privateKey')
	),
	expiration: now() + |PT3550S|
}
```

Example HMAC usage:

```dataweave
%dw 2.0
import jwt::HMAC
output application/json
---
HMAC::JWT({
            "firstName": "Michael",
            "lastName": "Jones"
          }, "Mulesoft123!")
```
