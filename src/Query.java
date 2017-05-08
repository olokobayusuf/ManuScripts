/*
*   ManuScripts
*   CS 61 - 17S
*/

import java.sql.*;

public class Query {

    //region --Op vars--
    
    private static Connection connection;
    private static Statement statement;
    private static final String
    SERVER = "jdbc:mysql://sunapee.cs.dartmouth.edu/",
    DATABASE = "yusuf_db",
    USERNAME = "yusuf",
    PASSWORD = "salihu";
    //endregion


    //region --Client API--

    public Query (String query) {

    }

    public void execute () {

    }
    //endregion


    //region --Initialization--

    static {
        try {
            // Load MySQL driver
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            // Establish connection with MySQL
            connection = DriverManager.getConnection(SERVER + DATABASE, USERNAME, PASSWORD);
            // Initialize a query statement
            statement = connection.createStatement();
            // Log
            Utility.logVerbose(connection.isValid(1) ? "Successfully connected to server" : "Failed to connect to server");
        } catch (Exception ex) {
            // Log error
            Utility.logError("Failed to connect to SQL server with exception: "+ex);
        }
    }
    //endregion
}