/*
*   ManuScripts
*   CS 61 - 17S
*/

import java.util.Scanner;

public class ManuScripts {

    /*
    * Application entry point. This passes on control to a suitable frontend
    */
    public static void main (String[] args) {
        // Set verbose mode
        Utility.setVerbose(args.length == 1 && (args[0].equals("--verbose") || args[0].equals("-v")));
        // Create a scanner
        Scanner scanner = new Scanner(System.in);
        // Declare a user
        User user = null;
        // REPL loop
        while (user == null && scanner.hasNextLine()) {
            // Split
            String tokens[] = scanner.nextLine().split("\\s");
            // Check command type
            if (tokens[0].equals("register")) user = User.register(tokens);
            if (tokens[0].equals("login")) user = User.login(Integer.parseInt(tokens[1]));
        }
        // Begin user UI
        if (user != null) user.evaluate(scanner);
        // Say bye
        Utility.log("Bye!");
    }
}