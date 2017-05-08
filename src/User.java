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
        String userID = new Query("user")
            .insert("fname", "lname")
            .values(tokens[2], tokens[3])
            .execute()
            .getID();
        // Register the user type
        Query newType = null;
        String type = tokens[1];
        if (type.equalsIgnoreCase("author")) newType = new Query("author").insert("user_id", "email", "address").values(userID, tokens[4], tokens[5]);
        if (type.equalsIgnoreCase("editor")) newType = new Query("editor").insert("user_id").values(userID);
        if (type.equalsIgnoreCase("reviewer")) newType = new Query("reviewer").insert("user_id", "email").values(userID, tokens[4]);
        // Add the user
        newType.execute();
        // Add reviewer RICodes
        if (type.equalsIgnoreCase("reviewer")) {
            // ...
        }
        // Return null
        return null;
    }

    public static User login (String id) {
        // Exeucte a direct query
        ResultSet result = new Query(null)
            .direct("SELECT 'author' AS author, COUNT(*) FROM author WHERE user_id = ? UNION SELECT 'editor' AS editor, COUNT(*) FROM editor WHERE user_id = ? UNION SELECT 'reviewer' as reviewer, COUNT(*) FROM reviewer WHERE user_id = ?")
            .values(Collections.nCopies(3, id).toArray(new String[0]))
            .execute()
            .getResult();
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