/*
*   ManuScripts
*   CS 61 - 17S
*/

import java.util.Scanner;

public class Editor extends User {

    //region --Ctor--

    public Editor (String id) {
        super(id);
        Utility.log("Hello editor!");
    }
    //endregion


    //region --REPL--

    @Override
    public void evaluate (Scanner scanner) {

    }
    //endregion
}