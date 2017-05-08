/*
*   ManuScripts
*   CS 61 - 17S
*/

public class Utility {

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
}