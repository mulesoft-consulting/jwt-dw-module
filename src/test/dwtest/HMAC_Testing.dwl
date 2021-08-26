%dw 2.0
import jwt::HMAC
output application/json
---
HMAC::JWT(payload, "Mulesoft123!")