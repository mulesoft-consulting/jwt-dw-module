%dw 2.0
import HMACBinary from dw::Crypto
import fail from dw::Runtime
import jwt::Common

var algMapping = {
    "HmacSHA256": "HS256",
    "HmacSHA384": "HS384",
    "HmacSHA512": "HS512"
}

fun alg(algorithm: String) : String | Null =
    algMapping[algorithm] default fail('Invalid algorithm provided for signing')

fun signJWT(content: String, key: String, alg: String) : String =
    Common::base64URL(HMACBinary(key as Binary, content as Binary, alg))

/** JWT with header, payload, and signature by specific algorithm. valid algorithms dictated by HMACWith */
fun JWT(header: Object, payload: Object, signingKey: String, algorithm: String) : String = do {
    var jwt = Common::JWT({
        (header - "alg" - "typ"),
        alg: alg(algorithm),
        typ: "JWT"
    }, payload)
    ---
    "$(jwt).$(signJWT(jwt, signingKey, algorithm))"
}

/** JWT with header, payload, and signed with HMAC-SHA256*/
fun JWT(header: Object, payload: Object, signingKey: String) : String = do {
    JWT(header, payload, signingKey, 'HmacSHA256')
}

/** JWT with payload and automatically generated header, signed with HMAC-SHA256 */
fun JWT(payload: Object, signingKey: String) : String =
    JWT( {},payload, signingKey, 'HmacSHA256')