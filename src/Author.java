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
    public void evaluate (String[] args, Scanner scanner) {
        if (args[0].equalsIgnoreCase("status")) status();
        else if (args[0].equalsIgnoreCase("submit")) submit(args);
        else if (args[0].equalsIgnoreCase("retract")) retract(args, scanner);
        else Utility.logError("Unrecognized command received. Try again");
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
    protected void status () { // INCOMPLETE
        // SQL command?
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

    private void retract (String[] args, Scanner scanner) { // INCOMPLETE
        // Are you sure?
        Utility.log("Are you sure? (Y/N)");
        // Are they sure?
        if (!Utility.nextLine(scanner).toLowerCase().startsWith("y")) return;
        // ...
        Utility.log("Okay");
        //new Query("manuscript").delete().where("id = ?", id);
    }
    //endregion
}