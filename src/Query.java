/*
*   ManuScripts
*   CS 61 - 17S
*/

import java.sql.*;
import java.util.Collections;
import java.util.stream.IntStream;

public class Query {

    //region --Op vars--

    private String[] attributes, data;
    private QueryType type;
    private final String table;
    public final int SUCCESS = 0, FAILED = -1;

    private enum QueryType {Insert, Update, Delete}
    private static Connection connection;
    private static final String
    SERVER = "jdbc:mysql://sunapee.cs.dartmouth.edu/",
    DATABASE = "yusuf_db",
    USERNAME = "yusuf",
    PASSWORD = "salihu";
    //endregion


    //region --Client API--

    public Query (String table) {
        this.table = table;
    }

    public Query insert (String... attributes) {
        type = QueryType.Insert;
        this.attributes = attributes;
        return this;
    }

    public Query values (String... data) {
        this.data = data;
        return this;
    }

    public Query where (String attribute, String data) {
        // ...
        return this;
    }

    public int execute () {
        int result = SUCCESS;
        switch (type) {
            case Insert:
                // Build the query
                String query = String.format(
                    "INSERT INTO %s %s VALUES (%s);",
                    table,
                    attributes != null ? String.format("(%s)", String.join(", ", attributes)) : "",
                    String.join(", ", Collections.nCopies(data.length, "?"))
                );
                // Log
                Utility.logVerbose("Preparing query: "+query);
                // Fill in statement
                try {
                    final PreparedStatement statement = connection.prepareStatement(query, PreparedStatement.RETURN_GENERATED_KEYS);
                    for (int i = 0; i < data.length; i++) statement.setString(i + 1, data[i]);
                    statement.executeUpdate();
                    result = statement.getGeneratedKeys().getInt(1);
                } catch (SQLException ex) {
                    Utility.logError("Failed to execute query: "+ex);
                    result = FAILED;
                }
                break;
        }
        return result;
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