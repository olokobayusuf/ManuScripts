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
    public void evaluate (String[] args, Scanner scanner) {

    }
    //endregion


    //region --Operations--

    @Override
    protected void welcome () {
        Utility.logVerbose("Starting editor UI...");
        // Query name and address
        ResultSet result = new Query("user")
            .select("fname", "lname")
            .where("id = ?", id)
            .execute()
            .getResult();
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

    }
    //endregion
}