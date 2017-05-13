/*
*   ManuScripts
*   CS 61 - 17S
*/

import java.sql.*;
import java.util.Scanner;

public class Author extends User {

    //region --Ctor--

    public Author (String id) {
        super(id);
    }
    //endregion


    //region --REPL--

    @Override
    public boolean evaluate (String[] args, Scanner scanner) {
        if (args[0].equalsIgnoreCase("status")) status();
        else if (args[0].equalsIgnoreCase("submit")) submit(args);
        else if (args[0].equalsIgnoreCase("retract")) retract(args, scanner);
        else if (args[0].equalsIgnoreCase("logout")) return false;
        else Utility.logError("Unrecognized command received. Try again");
        return true;
    }
    //endregion


    //region --Operations--

    @Override
    protected void welcome () {
        Utility.logVerbose("Starting author UI...");
        // Query name and address
        ResultSet result = new Query("SELECT fname, lname, address FROM user, author WHERE author.user_id = user.id AND user.id = ?")
            .with(id)
            .execute();
        // Welcome :)
        try {
            result.next();
            Utility.log(String.format(
                "Welcome Author %s %s from %s",
                result.getObject(1).toString(),
                result.getObject(2).toString(),
                result.getObject(3).toString()
            ));
        } catch (SQLException ex) {
            Utility.logError("Failed to retrieve author info: "+ex);
        }
    }

    @Override
    protected void status () {
        // Get the manuscripts
        ResultSet result = new Query("SELECT manuscript_id, title, status, timestamp FROM LeadAuthorManuscripts WHERE user_id = ?").with(id).execute();
        // Print
        Utility.log("\nStatus: ");
        Utility.print(result, true);
    }

    private void submit (String[] args) { // DEPLOY
        // Arg checking
        if (args.length > 5) {
            Utility.logError("Cannot submit manuscript with more than three contributing authors");
            return;
        }
        // Add manuscript
        int manuscript = new Query("INSERT INTO manuscript (author_id, RICodes_code, title, status, timestamp) VALUES (?, ?, ?, ?, NOW())").with(id, args[2], args[1], "submitted").insert();
        // Add contributors
        for (int i = 3; i < args.length; i++) {
            String[] name = args[i].split("\\s");
            new Query("INSERT INTO contributors (manuscript_id, order, fname, lname)").with(manuscript, i - 2, name[0], name[name.length - 1]);
        }
    }

    private void retract (String[] args, Scanner scanner) {
        // Check that it is ours
        String manuscript = args[1];
        try {
            ResultSet authorID = new Query("SELECT author_id FROM manuscript WHERE id = ?").with(manuscript).execute(); authorID.next();
            if (!authorID.getObject(1).toString().equalsIgnoreCase(id)) {
                Utility.logError("You cannot delete a manuscript that is not yours");
                return;
            }
        } catch (SQLException ex) {
            Utility.logError("Unable to retrieve manuscript for deletion: "+ex);
            return;
        }
        // Are you sure?
        Utility.log("Are you sure? (Y/N)");
        if (!Utility.nextLine(scanner).toLowerCase().startsWith("y")) return;
        // Delete
        new Query("DELETE FROM manuscript WHERE id = ?").with(manuscript).update();
    }
    //endregion
}