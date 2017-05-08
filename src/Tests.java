/*
*   ManuScripts
*   CS 61 - 17S
*/

public class Tests {

    public static void test (String[] args) {
        // Enable verbose mode
        Utility.setVerbose(true);
        // Log
        Utility.log("Starting ManuScripts testing mode");
        // Insert test
        insertTest();
    }

    static void insertTest () {
        // Create a user
        int id = new Query("user")
            .insert("fname", "lname")
            .values("Lanre", "Olokoba")
            .execute();
        // Log
        Utility.log("Created new user with ID: "+id);
    }
}