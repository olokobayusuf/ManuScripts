import java.util.Scanner;
import java.util.Formatter;
import javax.crypto.*;
import java.security.*;
import javax.crypto.spec.SecretKeySpec;


/*
*   ManuScripts
*   CS 61 - 17S
*/

public class Utility {

    private final static String HEX = "0123456789ABCDEF";

    //region --Logging--

    private static boolean verbose;

    public static void setVerbose (boolean verbose) {
        Utility.verbose = verbose;
    }

    public static void log (String log) {
        System.out.println(log);
    }

    public static void logVerbose (String log) {
        if (verbose) System.out.println("Logging: "+log);
    }

    public static void logError (String error) {
        System.err.println(error);
    }
    //endregion


    //region --Input--
    
    public static String nextLine (Scanner scanner) {
        System.out.print("=> ");
        if (scanner.hasNextLine()) return scanner.nextLine();
        else {
            log(""); // Go to a new line
            return null;
        }
    }
    //endregion


    /**
     * Encryption of a given text using the provided secretKey
     * 
     * @param text
     * @param secretKey
     * @return the encoded string
     */
    public static String encrypt(String text, String secretKey) {
        if (secretKey.length() != 16) {
            logError("Secret key must be 16 characters");
            return null;
        }
        try {
            Key sk = new SecretKeySpec(secretKey.getBytes(), "AES");

            Cipher aesCipher = Cipher.getInstance("AES");
            aesCipher.init(Cipher.ENCRYPT_MODE, sk);

            byte[] results = aesCipher.doFinal(text.getBytes());
            return toHex(results);
            
       } catch (NoSuchAlgorithmException e) {
            logError("NoSuchAlgorithmException when attempting to encrypt");
            return null;
        } catch (InvalidKeyException e) {
            logError("InvalidKeyException when attempting to encrypt");
            return null;
        } catch (IllegalBlockSizeException e) {
            logError("IllegalBlockSizeException when attempting to encrypt");
            return null;
        } catch (NoSuchPaddingException e) {
            logError("NoSuchPaddingException when attempting to encrypt");
            return null;
        } catch (BadPaddingException e) {
            logError("BadPaddingException when attempting to encrypt");
            return null;
        }
    }

    public static String decrypt(String text, String secretKey) {
        if (secretKey.length() != 16) {
            logError("Secret key must be 16 characters");
            return null;
        }
        try {
            Key sk = new SecretKeySpec(secretKey.getBytes(), "AES");

            Cipher aesCipher = Cipher.getInstance("AES");
            aesCipher.init(Cipher.DECRYPT_MODE, sk);

            byte[] results = aesCipher.doFinal(toByte(text));
            return new String(results);
            
       } catch (NoSuchAlgorithmException e) {
            logError("NoSuchAlgorithmException when attempting to decrypt");
            return null;
        } catch (InvalidKeyException e) {
            logError("InvalidKeyException when attempting to decrypt");
            return null;
        } catch (IllegalBlockSizeException e) {
            logError("IllegalBlockSizeException when attempting to decrypt");
            return null;
        } catch (NoSuchPaddingException e) {
            logError("NoSuchPaddingException when attempting to decrypt");
            return null;
        } catch (BadPaddingException e) {
            logError("BadPaddingException when attempting to decrypt");
            return null;
        }
    }


    /* 
     * toByte and toHex used from:
     * http://stackoverflow.com/questions/23361224/how-to-generate-a-128-bit-key-to-use-in-aes-algorithm 
     * in order to fix padding issues in encryption
     *
     */
    private static byte[] toByte(String data) throws NullPointerException{
        int len = data.length()/2;
        byte[] result = new byte[len];
        for (int i = 0; i < len; i++)
            result[i] = Integer.valueOf(data.substring(2*i, 2*i+2), 16).byteValue();
        return result;
    }

    private static String toHex(byte[] doFinal) {
        StringBuffer result = new StringBuffer(2*doFinal.length);
        for (int i = 0; i < doFinal.length; i++) {
            result.append(HEX.charAt((doFinal[i]>>4)&0x0f)).append(HEX.charAt(doFinal[i]&0x0f));
        }
        return result.toString();
    }
}