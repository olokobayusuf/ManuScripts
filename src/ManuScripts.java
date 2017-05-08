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
        User user = null;
        while (user == null && scanner.hasNextLine()) {
            String tokens[] = scanner.nextLine().split("\\s");
            // Check command type
            if (tokens[0].equals("register")) user = User.register(tokens);
            if (tokens[0].equals("login")) user = User.login(tokens[1]);
        }
        // Begin user UI
        if (user != null) user.evaluate(scanner);
        // Say bye
        Utility.log("Bye!");
    }
}