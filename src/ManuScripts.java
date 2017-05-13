/*
*   ManuScripts
*   CS 61 - 17S
*/

import java.util.Scanner;
import java.util.stream.Stream;

public final class ManuScripts {

    /*
    * Application entry point. This passes on control to a suitable frontend
    */
    public static void main (String[] args) {
        // Set verbose mode
        Utility.setVerbose(Stream.of(args).anyMatch(arg -> arg.equalsIgnoreCase("--verbose") || arg.equalsIgnoreCase("-v")));
        // Run tests
        if (Stream.of(args).anyMatch(arg -> arg.equalsIgnoreCase("--test") || arg.equalsIgnoreCase("-t"))) {
            Tests.test(args);
            return;
        }
        // Start REPL
        Utility.log("Welcome to ManuScripts");
        Auth.getPassword();
        //Utility.log("Please enter the master key (16 characters):");
        Scanner scanner = new Scanner(System.in);
        String input = "";
        String tokens[];
        /*
        String secretKey = "";
        while (secretKey.length() != 16) {
            input = Utility.nextLine(scanner);
            tokens = input.split("\\s");
            secretKey = tokens[0];
            if (secretKey.length() != 16)
                Utility.log("The master key must be 16 characters");
        } */
        Utility.log("Please authenticate yourself by registering or logging in:");
        User user = null;
        while ((input = Utility.nextLine(scanner)) != null) {
            tokens = Utility.tokenize(input);
            if (tokens.length == 0) continue;
            // Check command type
            if (tokens[0].equalsIgnoreCase("register")) user = User.register(tokens);
            else if (tokens[0].equalsIgnoreCase("login")) user = User.login(tokens[1]);
            else if (tokens[0].equalsIgnoreCase("exit")) break;
            else if (tokens[0].equalsIgnoreCase("quit")) break;
            else Utility.logError("Unrecognized command received. Try again");
            // User REPL
            while (user != null && (input = Utility.nextLine(scanner)) != null && user.evaluate(input.split("\\s"), scanner)) ;
            // Log out
            if (user != null) Utility.log("Logging out...");
            user = null;
        }
        // Say bye
        Utility.log("Bye!");
        Query.close();
    }
}