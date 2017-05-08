/*
*   ManuScripts
*   CS 61 - 17S
*/

import java.util.Scanner;

public class Reviewer extends User {

    //region --Ctor--

    public Reviewer (String id) {
        super(id);
        Utility.log("Hello reviewer!");
    }
    //endregion


    //region --REPL--

    @Override
    public void evaluate (Scanner scanner) {

    }
    //endregion
}