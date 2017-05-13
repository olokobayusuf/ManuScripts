/*
*   ManuScripts
*   CS 61 - 17S
*/

import java.sql.*;
import java.util.Scanner;

public class Editor extends User {

    //region --Ctor--

    public Editor (String id) {
        super(id);
    }
    //endregion


    //region --REPL--

    @Override
    public boolean evaluate (String[] args, Scanner scanner) {
        if (args[0].equalsIgnoreCase("status")) status();
        else if (args[0].equalsIgnoreCase("assign")) assign(args[1], args[2]);
        else if (args[0].equalsIgnoreCase("accept")) accept(args[1]);
        else if (args[0].equalsIgnoreCase("reject")) reject(args[1]);
        else if (args[0].equalsIgnoreCase("typeset")) typeset(args[1], args[2]);
        else if (args[0].equalsIgnoreCase("issue")) ;
        else if (args[0].equalsIgnoreCase("schedule")) ;
        else if (args[0].equalsIgnoreCase("publish")) ;
        else if (args[0].equalsIgnoreCase("logout")) return false;
        else Utility.logError("Unrecognized command received. Try again");
        return true;
    }
    //endregion


    //region --Operations--

    @Override
    protected void welcome () {
        Utility.logVerbose("Starting editor UI...");
        // Query name and address
        ResultSet result = new Query("SELECT fname, lname FROM user WHERE id = ?").with(id).execute();
        // Welcome :)
        try {
            result.next();
            Utility.log(String.format(
                "Welcome Editor %s %s",
                result.getObject(1).toString(),
                result.getObject(2).toString()
            ));
        } catch (SQLException ex) {
            Utility.logError("Failed to retrieve editor info: "+ex);
        }
    }

    @Override
    protected void status () {
        // Get all manuscripts
        ResultSet result = new Query("SELECT id, author_id, RICodes_code, title, status, timestamp FROM manuscript ORDER BY FIELD(status, 'submitted', 'underreview', 'rejected', 'accepted', 'typeset', 'scheduled', 'published'), id").execute();
        // Print
        Utility.log("\nStatus: ");
        Utility.print(result, true);
    }

    private void assign (String manuscript, String reviewer) {
        try {
            ResultSet result;
            // Make sure that the manuscript is in the submitted or reviewing state
            (result = new Query("SELECT COUNT(*) FROM manuscript WHERE id = ? AND (status = 'submitted' OR status = 'underreview')").with(manuscript).execute()).next();
            if (Integer.parseInt(result.getObject(1).toString()) == 0) {
                Utility.logError("You cannot assign a reviewer to this manuscript because it is not pending review");
                return;
            }
            // Make sure the reviewer supports this RI code
            (result = new Query("SELECT COUNT(*) FROM (SELECT * FROM interests WHERE reviewer_id = ?) AS contributor INNER JOIN (SELECT * FROM manuscript WHERE id = ?) AS manuscript ON contributor.RICodes_code = manuscript.RICodes_code").with(reviewer, manuscript).execute()).next();
            if (Integer.parseInt(result.getObject(1).toString()) == 0) {
                Utility.logError("You cannot assign this reviewer to this manuscript because they do not specialize in the subject");
                return;
            }
            // Create a new review
            new Query("INSERT INTO review (manuscript_id, reviewer_id, dateSent) VALUES (?, ?, NOW())").with(manuscript, reviewer).insert();
            // Update the manuscript status
            new Query("UPDATE manuscript SET status = 'underreview', timestamp = NOW() WHERE id = ?").with(manuscript).update();
        } catch (SQLException ex) {
            Utility.logError("Failed to assign manuscript: "+ex);
        }
    }

    private void accept (String id) {
        new Query("UPDATE manuscript SET status = 'accepted', timestamp = NOW() WHERE id = ?").with(id).update();
    }

    private void reject (String id) {
        new Query("UPDATE manuscript SET status = 'rejected', timestamp = NOW() WHERE id = ?").with(id).update();
    }

    private void typeset (String id, String pages) {
        new Query("UPDATE manuscript SET status = 'typeset', timestamp = NOW(), pageCount = ? WHERE id = ?").with(pages, id).update();
    }

    private void issue () { // INCOMPLETE
        
    }

    private void schedule () { // INCOMPLETE

    }

    private void publish () { // INCOMPLETE

    }
    //endregion
}