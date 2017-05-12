/*
*   ManuScripts
*   CS 61 - 17S
*/

import java.sql.*;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.stream.IntStream;

public class Query {

    //region --Op vars--

    private final String query;
    private Object values[] = {};

    private static Connection connection;
    private static final String
    SERVER = "jdbc:mysql://sunapee.cs.dartmouth.edu/",
    DATABASE = "yusuf_db",
    USERNAME = "yusuf",
    PASSWORD = "salihu";
    //endregion


    //region --Client API--

    public Query (String query) {
        this.query = query;
    }

    public Query with (Object... values) {
        this.values = values;
        return this;
    }

    public int insert () {
        try {
            PreparedStatement statement = prepare();
            statement.executeUpdate();
            return statement.getGeneratedKeys().getInt(1);
        } catch (SQLException ex) {
            Utility.logError("Failed to execute query: "+ex);
        }
        return -1;
    }

    public ResultSet execute () {
        try {
            return prepare().executeQuery();
        } catch (SQLException ex) {
            Utility.logError("Failed to execute query: "+ex);
        }
        return null;
    }

    public void update () {
        try {
            prepare().executeUpdate();
        } catch (SQLException ex) {
            Utility.logError("Failed to execute query: "+ex);
        }
    }
    //endregion


    //region --Operations--

    private PreparedStatement prepare () {
        Utility.logVerbose("Preparing query: "+query);
        try {
            final PreparedStatement statement = connection.prepareStatement(query, PreparedStatement.RETURN_GENERATED_KEYS);
            for (int i = 0; i < values.length; i++) statement.setString(i + 1, values[i].toString());
            return statement;
        } catch (SQLException ex) {
            Utility.logError("Failed to preapre query: "+ex);
        }
        return null;
    }
    //endregion


    //region --Initialization--

    static {
        try {
            // Load MySQL driver
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            // Establish connection with MySQL
            connection = DriverManager.getConnection(SERVER + DATABASE, USERNAME, PASSWORD);
            // Log
            Utility.logVerbose(connection.isValid(1) ? "Successfully connected to server" : "Failed to connect to server");
        } catch (Exception ex) {
            // Log error
            Utility.logError("Failed to connect to SQL server with exception: "+ex);
        }
    }
    //endregion
}