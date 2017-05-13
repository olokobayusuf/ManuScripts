import java.util.Arrays;

/*
*   ManuScripts
*   CS 61 - 17S
*/

public final class Auth {

    public static char[] getPassword () {
        char[] password, confirm;
        // Security paranoia
        if (Arrays.equals(password = System.console().readPassword("Enter password: "), confirm = System.console().readPassword("Confirm password: "))) {
            Arrays.fill(confirm, (char)0x00);
            return password;
        }
        Utility.logError("Password mismatch. Please try again");
        Arrays.fill(password, (char)0x00);
        Arrays.fill(confirm, (char)0x00);
        return null;
    }
}