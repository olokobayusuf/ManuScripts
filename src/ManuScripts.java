/*
*   ManuScripts
*   CS 61 - 17S
*/

import java.util.Scanner;
import java.util.stream.Stream;

public class ManuScripts {

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
        // REPL loop
        Scanner scanner = new Scanner(System.in);
        String input;
        User user = null;
        while (user == null && (input = Utility.nextLine(scanner)) != null) {
            String tokens[] = input.split("\\s");
            // Check command type
            if (tokens[0].equalsIgnoreCase("register")) user = User.register(tokens);
            else if (tokens[0].equalsIgnoreCase("login")) user = User.login(tokens[1]);
            else Utility.logError("Unrecognized command received. Try again");
        }
        // Run user UI
        while (user != null && (input = Utility.nextLine(scanner)) != null) user.evaluate(input.split("\\s"), scanner);
        // Say bye
        Utility.log("Bye!");
    }
}