/*
*   ManuScripts
*   CS 61 - 17S
*/

import java.sql.*;
import java.util.Scanner;
import java.util.Collections;

public abstract class User {

    protected final String id;

    //region --Client API--

    public User (String id) {
        this.id = id;
        // Display welcome
        welcome();
        // Display status
        status();
    }

    public abstract void evaluate (String[] args, Scanner scanner);

    protected abstract void status ();

    protected abstract void welcome ();
    //endregion


    //region --Operations--

    public static User register (String[] tokens) { // INCOMPLETE
        // Create a user ID
        int userID = new Query("INSERT INTO user (fname, lname) VALUES (?, ?)").with(tokens[2], tokens[3]).insert();
        // Register the user type
        String type = tokens[1];
        if (type.equalsIgnoreCase("author")) new Query("INSERT INTO author (user_id, email, address) VALUES (?, ?, ?)").with(userID, tokens[4], tokens[5]).insert();
        if (type.equalsIgnoreCase("editor")) new Query("INSERT INTO editor (user_id) VALUES (?)").with(userID).insert();
        if (type.equalsIgnoreCase("reviewer")) new Query("INSERT INTO reviewer (user_id, email) VALUES (?, ?)").with(userID, tokens[4]).insert();
        // Add reviewer RICodes
        if (type.equalsIgnoreCase("reviewer")) {
            // ...
        }
        // Return null
        return null;
    }

    public static User login (String id) {
        // Exeucte a direct query
        ResultSet result = new Query("SELECT 'author' AS author, COUNT(*) FROM author WHERE user_id = ? UNION SELECT 'editor' AS editor, COUNT(*) FROM editor WHERE user_id = ? UNION SELECT 'reviewer' as reviewer, COUNT(*) FROM reviewer WHERE user_id = ?").with(id, id, id).execute();
        User user = null;
        try {
            while (result.next()) if (Integer.parseInt(result.getObject(2).toString()) == 1) {
                // Check user type
                String userType = result.getObject(1).toString();
                if (userType.equalsIgnoreCase("author")) user = new Author(id);
                if (userType.equalsIgnoreCase("editor")) user = new Editor(id);
                if (userType.equalsIgnoreCase("reviewer")) user = new Reviewer(id);
                break;
            }
        } catch (SQLException ex) {
            Utility.logError("Failed to get user type: "+ex);
        }
        // Error logging
        if (user == null) Utility.logError("Failed to login user with id: "+id);
        return user;
    }
    //endregion
}