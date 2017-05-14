/*
*   ManuScripts
*   CS 61 - 17S
*/

import java.util.Arrays;
import java.nio.CharBuffer;
import java.nio.ByteBuffer;
import java.nio.charset.Charset;
import javax.crypto.spec.SecretKeySpec;
import javax.crypto.*;
import java.security.*;

public final class Auth { // Ideally, hashing would be enough

    private static char[] masterKey;

    public static char[] getMasterKey () {
        while (masterKey == null) masterKey = (masterKey = System.console().readPassword("Enter 16-character master key: ")).length == 16 ? masterKey : null;
        return masterKey;
    }

    public static char[] getPassword (boolean confirm) {
        char[] password, repeat;
        // Security paranoia
        if (!confirm) return System.console().readPassword("Enter password: ");
        if (Arrays.equals(password = System.console().readPassword("Enter password: "), repeat = System.console().readPassword("Confirm password: "))) {
            Arrays.fill(repeat, (char)0x00);
            return password;
        }
        Utility.logError("Password mismatch. Please try again");
        return null;
    }

    /**
     * Encryption of a given text using the provided secretKey
     * @param text
     * @param secretKey
     * @return the encoded string
     */
    public static String encrypt (String text) {
        try {
            Key sk = new SecretKeySpec(new String(masterKey).getBytes(), "AES");
            Cipher aesCipher = Cipher.getInstance("AES");
            aesCipher.init(Cipher.ENCRYPT_MODE, sk);
            byte[] results = aesCipher.doFinal(text.getBytes());
            return toHex(results);
       } catch (NoSuchAlgorithmException | InvalidKeyException | IllegalBlockSizeException | NoSuchPaddingException | BadPaddingException ex) {
            Utility.logError("Failed to encrypt string: "+ex);
            return null;
        }
    }

    public static String decrypt (String text) {
        try {
            Key sk = new SecretKeySpec(new String(masterKey).getBytes(), "AES");
            Cipher aesCipher = Cipher.getInstance("AES");
            aesCipher.init(Cipher.DECRYPT_MODE, sk);
            byte[] results = aesCipher.doFinal(toBytes(text));
            return new String(results);
       } catch (NoSuchAlgorithmException | InvalidKeyException | IllegalBlockSizeException | NoSuchPaddingException | BadPaddingException ex) {
            Utility.logError("Failed to decrypt string: "+ex);
            return null;
        }
    }

    /* 
     * toByte and toHex used from:
     * http://stackoverflow.com/questions/23361224/how-to-generate-a-128-bit-key-to-use-in-aes-algorithm 
     * in order to fix padding issues in encryption
     */
    private static byte[] toBytes (String data) {
        byte[] result = new byte[data.length() / 2];
        for (int i = 0; i < result.length; i++) result[i] = Integer.valueOf(data.substring(2 * i, 2 * i + 2), 16).byteValue();
        return result;
    }

    private static String toHex (byte[] doFinal) {
        StringBuffer result = new StringBuffer(2 * doFinal.length);
        for (int i = 0; i < doFinal.length; i++) result.append(masterKey[(doFinal[i] >> 4) & 0x0f]).append(masterKey[doFinal[i] & 0x0f]);
        //for (int i = 0; i < doFinal.length; i++) result.append(HEX.charAt((doFinal[i]>>4)&0x0f)).append(HEX.charAt(doFinal[i]&0x0f));
        return result.toString();
    }

    /**
     * Encode character sequence to bytes without going through String to prevent security hole
     */
    /*
    private static byte[] toBytes (char[] sequence) {
        CharBuffer chars = CharBuffer.wrap(sequence);
        ByteBuffer bytes = Charset.forName("UTF-8").encode(chars);
        byte[] data = Arrays.copyOfRange(bytes.array(), bytes.position(), bytes.limit());
        Arrays.fill(chars.array(), (char)0);
        Arrays.fill(bytes.array(), (byte)0);
        return data;
    }
    */
}