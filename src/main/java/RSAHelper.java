import java.io.UnsupportedEncodingException;
import java.security.*;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.util.Base64;

public class RSAHelper {
    public static String signString(String content, String privateKeyContent, String algorithm) throws NoSuchAlgorithmException, InvalidKeySpecException, InvalidKeyException, UnsupportedEncodingException, SignatureException {
        KeyFactory kf = KeyFactory.getInstance("RSA");
        PKCS8EncodedKeySpec keySpecPKCS8 = new PKCS8EncodedKeySpec(Base64.getDecoder().decode(privateKeyContent));
        PrivateKey pk = kf.generatePrivate(keySpecPKCS8);

        Signature privateSignature = Signature.getInstance(algorithm);
        privateSignature.initSign(pk);
        privateSignature.update(content.getBytes("UTF-8"));
        byte[] s = privateSignature.sign();
        return Base64.getUrlEncoder().encodeToString(s).replace("=", "");
    }
}