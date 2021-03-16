package com.Klaus.jdbcNotes;

import java.sql.*;
import java.util.Scanner;

public class jdbcNotes {
    private static final String url = "jdbc:mysql://localhost:3306/Notes";
    private static final String usr = "java-user";
    private static final  String pwd = "KVZmvv4Yjwo3";


    public static void main(String[] args) {
        while (true) {
        printNotes();
        newNoteFromScanner();
        }
    }

    private static void newNoteFromScanner() {
        Scanner sc = new Scanner(System.in);

        System.out.println("Bitte neue Notiz eingeben:");
        String note = sc.nextLine();

        Connection conn = null;
        try {
            conn = DriverManager.getConnection(url, usr, pwd);
            //System.out.println("Connection established");

            Statement stmt = conn.createStatement();
            stmt.executeUpdate("INSERT INTO Notes (text) VALUES (\"" + note + "\")");
            }
         catch (SQLException se) {
            se.printStackTrace();
        } finally {
            if (conn != null) {
                try{
                    conn.close();
                } catch (SQLException se){
                    se.printStackTrace();
                }

            }

        }

    }

    private static void printNotes() {
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(url, usr, pwd);
            System.out.println("Connection established");

            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT id, text, created FROM notes ORDER BY created ASC");

            while (rs.next()){
                int id = rs.getInt("id");
                String text = rs.getString("text");
                Date dateCreated = rs.getDate("created");
                Time timeCreated = rs.getTime("created");

                System.out.println("note " + id + " from " + dateCreated.toString() + " " + timeCreated.toString() + ": " + text);
            }
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            if (conn != null) {
                try{
                    conn.close();
                } catch (SQLException se){
                    se.printStackTrace();
                }

            }

        }
    }
}
