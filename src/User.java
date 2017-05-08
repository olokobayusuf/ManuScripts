/*
*   ManuScripts
*   CS 61 - 17S
*/

import java.util.Scanner;

public abstract class User {

    protected final int id;

    //region --Client API--

    public User (int id) {
        this.id = id;
    }

    public abstract void evaluate (Scanner scanner);
    //endregion


    //region --Operations--

    public static User register (String[] tokens) {
        // Create a registration query
        Query query = new Query("INSERT INTO users () VALUES ();");
        // Register the user type
        String type = tokens[1];
        if (type.equalsIgnoreCase("author")) {
            
        }
        if (type.equalsIgnoreCase("editor")) {

        }
        if (type.equalsIgnoreCase("reviewer")) {

        }
        // Return null
        Utility.logError("User type '"+type+"' not recognized");
        return null;
    }

    public static User login (int id) {
        return null;
    }
    //endregion
}