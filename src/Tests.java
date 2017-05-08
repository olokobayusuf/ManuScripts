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
        String id = new Query("user")
            .insert("fname", "lname")
            .values("Lanre", "Olokoba")
            .execute()
            .getID();
        // Log
        Utility.log("Created new user with ID: "+id);
    }

    static void userTypeTest () {
        final int userID = 21;
        // Exeucte a direct query
        ResultSet result = new Query(null)
            .direct("SELECT 'author' AS author, COUNT(*) FROM author WHERE user_id = ? UNION SELECT 'editor' AS editor, COUNT(*) FROM editor WHERE user_id = ? UNION SELECT 'reviewer' as reviewer, COUNT(*) FROM reviewer WHERE user_id = ?")
            .values(Collections.nCopies(3, Integer.toString(userID)).toArray(new String[0]))
            .execute()
            .getResult();
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