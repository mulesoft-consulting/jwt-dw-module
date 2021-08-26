%dw 2.0
import toBase64 from dw::core::Binaries

fun binaryJson(obj: Object) =
    write(obj, 'application/json', { indent: false }) as Binary

fun base64URL(str: Binary) =
    toBase64(str) replace "+" with "-" replace "/" with "_" replace "=" with ""

fun base64Obj(obj: Object) =
    base64URL(binaryJson(obj))

/** basic JWT with header and payload, no signing */
fun JWT(header: Object, payload: Object) =
    "$(base64Obj(header)).$(base64Obj(payload))"

/** basic JWT with no user specified header */
fun JWT(payload: Object) =
    JWT({typ:'JWT'}, payload)