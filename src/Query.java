/*
*   ManuScripts
*   CS 61 - 17S
*/

import java.sql.*;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.stream.IntStream;
import java.util.function.Consumer;

public class Query {

    //region --Op vars--

    private final String query;
    private Object values[] = {};
    private Consumer<PreparedStatement> preparer;

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

    public Query onPrepare (Consumer<PreparedStatement> consumer) {
        preparer = consumer;
        return this;
    }

    public int insert () {
        try {
            PreparedStatement statement = prepare();
            if (preparer != null) preparer.accept(statement);
            statement.executeUpdate();
            ResultSet result = statement.getGeneratedKeys();
            if (result.next()) return result.getInt(1);
        } catch (SQLException ex) {
            Utility.logError("Failed to insert: "+ex);
        }
        return -1;
    }

    public ResultSet execute () {
        try {
            PreparedStatement statement = prepare();
            if (preparer != null) preparer.accept(statement);
            return statement.executeQuery();
        } catch (SQLException ex) {
            Utility.logError("Failed to execute: "+ex);
        }
        return null;
    }

    public void update () {
        try {
            PreparedStatement statement = prepare();
            if (preparer != null) preparer.accept(statement);
            statement.executeUpdate();
        } catch (SQLException ex) {
            Utility.logError("Failed to update: "+ex);
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
            Utility.logError("Failed to prepare query: "+ex);
        }
        return null;
    }
    //endregion


    //region --State Management--

    static {
        try {
            // Load MySQL driver
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            // Establish connection with MySQL
            connection = DriverManager.getConnection(SERVER + DATABASE, USERNAME, PASSWORD);
            Utility.logVerbose(connection.isValid(1) ? "Successfully connected to database" : "Failed to connect to database");
        } catch (Exception ex) {
            Utility.logError("Failed to connect to database: "+ex);
        }
    }

    public static void close () {
        try {
            if (connection != null) connection.close();
            connection = null;
            Utility.logVerbose("Closed connection to database");
        } catch (SQLException ex) {
            Utility.logError("Failed to close connection to database: "+ex);
        }
    }
    //endregion
}