package com.genercs.example;

import java.sql.Connection;
import java.sql.Driver;
import java.sql.DriverManager;

public class Dbwork {
    //making the connection of our application with PostgreSQL
    public Connection connect_to_db(String dbname,String user,String pass){
        //making the object of Connection
        Connection conn = null;
        try{
            //load postgreSQL driver
            Class.forName("org.postgresql.Driver");
            //setting up the connection
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/"+dbname,user,pass);
            //passing condition to check the connection is successfull or not
            if(conn != null) {
                System.out.println("Connection established!");
            }else{
                System.out.println("Connection Failed");
            }
        }catch (Exception e){
            System.out.println(e);
        }
        return conn;
    }
}
