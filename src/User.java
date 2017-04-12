/*
*   ManuScripts
*   CS 61 - 17S
*/

import java.util.Scanner;

public abstract class User {

    //region --Client API--
    public abstract void evaluate (Scanner scanner);
    //endregion


    //region --Operations--
    public static User login () {
        return null;
    }
    //endregion
}