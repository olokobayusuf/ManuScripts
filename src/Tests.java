/*
*   ManuScripts
*   CS 61 - 17S
*/

import java.sql.*;
import java.util.Collections;

public class Tests {

    public static void test (String[] args) {
        // Enable verbose mode
        Utility.setVerbose(true);
        // Log
        Utility.log("Starting ManuScripts testing mode");
        // Insert test
        //insertTest();
        // User type test
        userTypeTest();
    }

    static void insertTest () {
        // Create a user
        Integer id = new Query("INSERT INTO user (fname, lname) VALUES (?, ?)").with("Lanre", "Olokoba").insert();
        // Log
        Utility.log("Created new user with ID: "+id);
    }

    static void userTypeTest () {
        final int userID = 21;
        // Exeucte a query
        ResultSet result = new Query("SELECT 'author' AS author, COUNT(*) FROM author WHERE user_id = ? UNION SELECT 'editor' AS editor, COUNT(*) FROM editor WHERE user_id = ? UNION SELECT 'reviewer' as reviewer, COUNT(*) FROM reviewer WHERE user_id = ?").with(userID, userID, userID).execute();
        // Iterate and print
        String userType = "None";
        try {
            while (result.next()) if (Integer.parseInt(result.getObject(2).toString()) == 1) {
                userType = result.getObject(1).toString();
                break;
            }
        } catch (SQLException ex) {
            Utility.logError("Failed to get user type: "+ex);
        }
        // Log
        Utility.log("User type for '"+userID+"' is: "+userType);
    }
}