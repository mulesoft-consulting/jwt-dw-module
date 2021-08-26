%dw 2.0
import java!RSAHelper
import jwt::Common
import fail from dw::Runtime

var algMapping = {
    "Sha256withRSA": "RS256",
    "Sha384withRSA": "RS384",
    "Sha512withRSA": "RS512"
}

fun alg(algorithm: String) : String | Null =
    algMapping[algorithm] default fail('Invalid algorithm provided for signing')

fun cleanKey(key: String) : String =
    log(key replace "\n" with "" replace /(-+)(BEGIN|END)(\sRSA)? (PRIVATE|PUBLIC) KEY(-+)/ with "" replace " " with "")

fun signJWT(jwt: String, privateKey: String, algorithm: String) : String =
    RSAHelper::signString(jwt, privateKey, algorithm)

/** JWT with header, payload, and signature by specific algorithm. valid algorithms dictated by HMACWith */
fun JWT(header: Object, payload: Object, pkcs8privateKey: String, algorithm: String) : String = do {
    var jwt = Common::JWT(
    { (header - "alg" - "typ"), alg: alg(algorithm), typ: 'JWT' },
    payload)
    ---
    "$(jwt).$(signJWT(jwt, pkcs8privateKey, algorithm))"
}

/** JWT with payload and automatically generated header, signed with HMAC-SHA256 */
fun JWT(payload: Object, pkcs8privateKey: String) : String =
    JWT({}, payload, pkcs8privateKey, "Sha256withRSA")