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
        // Create a scanner
        Scanner scanner = new Scanner(System.in);
        // Declare a user
        User user = null;
        // REPL loop
        while (user == null && scanner.hasNextLine()) {
            // Split
            String tokens[] = scanner.nextLine().split("\\s");
            // Check command type
            if (tokens[0].equals("register")) ;
            if (tokens[0].equals("login")) user = User.login();
            System.out.println("You said: "+tokens[0]);
        }
        // Begin user UI
        if (user != null) user.evaluate(scanner);
        // Say bye
        System.out.println("Bye!");
    }
}