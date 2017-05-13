<<<<<<< HEAD
=======
import java.util.Scanner;
import java.util.Formatter;
import javax.crypto.*;
import java.security.*;
import javax.crypto.spec.SecretKeySpec;


>>>>>>> 709bc45243e93532372f1e88ae259252e15df12a
/*
*   ManuScripts
*   CS 61 - 17S
*/

import java.util.Scanner;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.sql.*;
import java.util.regex.*;

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
    
    /** 
     * Tokenize an input string, paying attention to substrings within quotation marks
     * 'hello there "Professor X"' -> 'hello', 'there', 'Professor X'
     * Credits: http://stackoverflow.com/questions/366202/regex-for-splitting-a-string-using-space-when-not-surrounded-by-single-or-double
    */
    public static String[] tokenize (String input) {
        ArrayList<String> tokens = new ArrayList<String>();
        Matcher matcher = Pattern.compile("[^\\s\"']+|\"([^\"]*)\"|'([^']*)'").matcher(input);
        while (matcher.find())
            if (matcher.group(1) != null) tokens.add(matcher.group(1)); // Add double-quoted string without the quotes
            else if (matcher.group(2) != null) tokens.add(matcher.group(2)); // Add single-quoted string without the quotes
            else tokens.add(matcher.group()); // Add unquoted word
        return tokens.toArray(new String[] {});
    }
    //endregion


    //region --Output--

    public static void print (ResultSet result, boolean headers) {
        try {
            int columns = result.getMetaData().getColumnCount();
            for (int i = 1; i <= columns; i++) System.out.format("%-13s", result.getMetaData().getColumnName(i));
            System.out.println("");
            // Print info
            while (result.next()) {
                for (int i = 1; i <= columns; i++) System.out.format("%-13s", result.getObject(i) == null ? "—" : result.getObject(i) instanceof byte[] ? "BLOB" : result.getObject(i));
                System.out.println("");
            }
        } catch (SQLException ex) {
            Utility.logError("Failed to print result: "+ex);
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