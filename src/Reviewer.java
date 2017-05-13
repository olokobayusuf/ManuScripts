/*
*   ManuScripts
*   CS 61 - 17S
*/

import java.sql.*;
import java.util.Scanner;
import java.util.stream.Stream;

public class Reviewer extends User {

    //region --Ctor--

    public Reviewer (String id) {
        super(id);
    }
    //endregion


    //region --REPL--

    @Override
    public boolean evaluate (String[] args, Scanner scanner) {
        if (args[0].equalsIgnoreCase("status")) status();
        else if (args[0].equalsIgnoreCase("accept")) review(true, args);
        else if (args[0].equalsIgnoreCase("reject")) review(false, args);
        else if (args[0].equalsIgnoreCase("logout")) return false;
        else Utility.logError("Unrecognized command received. Try again");
        return true;
    }
    //endregion


    //region --Operations--

    @Override
    protected void welcome () {
        Utility.logVerbose("Starting reviewer UI...");
        // Query name and address
        ResultSet result = new Query("SELECT fname, lname FROM user WHERE id = ?").with(id).execute();
        // Welcome :)
        try {
            result.next();
            Utility.log(String.format(
                "Welcome Reviewer %s %s",
                result.getObject(1).toString(),
                result.getObject(2).toString()
            ));
        } catch (SQLException ex) {
            Utility.logError("Failed to retrieve reviewer info: "+ex);
        }
    }

    @Override
    protected void status () {
        // Get all manuscripts
        ResultSet result = new Query("CALL ReviewStatus(?)").with(id).execute();
        // Print
        Utility.log("\nStatus: ");
        Utility.print(result, true);
    }

    private void review (boolean accept, String[] args) { // DEPLOY
        // Arg checking
        if (args.length != 6) {
            Utility.logError("Incorrect arguments for manuscript review");
            return;
        }
        // Range checking
        if (Stream.of(args).skip(2).mapToInt(Integer::parseInt).anyMatch(x -> x < 1 || x > 10)) {
            Utility.logError("Feedback scores must be within [1, 10]");
            return;
        }
        // Query
        new Query("INSERT INTO feedback (manuscript_id, reviewer_id, appropriateness, clarity, methodology, contribution, recommendation, dateReceived) VALUES (?, ?, ?, ?, ?, ?, ?, NOW())")
            .with(args[1], id, args[2], args[3], args[4], args[5])
            .onPrepare(statement -> {
                try {
                    statement.setByte(7, accept ? (byte)1 : 0); // We need to use setByte instead of setString
                } catch (SQLException ex) {
                    Utility.logError("Failed to prepare feedback query: "+ex);
                }
            }).insert();
    }

    private void resign () { // INCOMPLETE

    }
    //endregion
}