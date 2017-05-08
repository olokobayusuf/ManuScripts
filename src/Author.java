/*
*   ManuScripts
*   CS 61 - 17S
*/

import java.util.Scanner;

public class Author extends User {

    //region --Ctor--

    public Author (String id) {
        super(id);
        Utility.log("Hello author!");
    }
    //endregion


    //region --REPL--

    @Override
    public void evaluate (Scanner scanner) {

    }
    //endregion


    //region --Operations--

    public void submit () {
        
    }
    //endregion
}