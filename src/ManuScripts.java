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
        // Check for auth mode
        boolean authenticate = Stream.of(args).anyMatch(arg -> arg.equalsIgnoreCase("--auth") || arg.equalsIgnoreCase("-a"));
        // Start REPL
        Utility.log("Welcome to ManuScripts");
        if (authenticate) Auth.getMasterKey();
        Scanner scanner = new Scanner(System.in);
        String input = "";
        Utility.log("Please authenticate yourself by registering or logging in:");
        User user = null;
        while ((input = Utility.nextLine(scanner)) != null) {
            String[] tokens = Utility.tokenize(input);
            if (tokens.length == 0) continue;
            // Check command type
            if (tokens[0].equalsIgnoreCase("register")) user = User.register(tokens, authenticate);
            else if (tokens[0].equalsIgnoreCase("login")) user = User.login(tokens[1], authenticate);
            else if (tokens[0].equalsIgnoreCase("exit")) break;
            else if (tokens[0].equalsIgnoreCase("quit")) break;
            else Utility.logError("Unrecognized command received. Try again");
            // User REPL
            while (user != null && (input = Utility.nextLine(scanner)) != null && user.evaluate(Utility.tokenize(input), scanner)) ;
            // Log out
            if (user != null) Utility.log("Logging out...");
            user = null;
        }
        // Say bye
        Utility.log("Bye!");
        Query.close();
    }
}