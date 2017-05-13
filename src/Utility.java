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
}