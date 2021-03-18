package com.Klaus.jdbcNotes;

import java.sql.*;
import java.util.Scanner;

public class jdbcNotes {
    private static final String url = "jdbc:mysql://localhost:3306/Notes";
    private static final String usr = "java-user";
    private static final  String pwd = "KVZmvv4Yjwo3";


    public static void main(String[] args) {
        int userId = chooseUser();
        while (true) {
        printNotes(userId);
        newNoteFromScanner(userId);
        }
    }



    private static void newNoteFromScanner(int userId) {
        Scanner sc = new Scanner(System.in);

        System.out.println("Please insert new note:");
        String note = sc.nextLine();

        Connection conn = null;
        try {
            conn = DriverManager.getConnection(url, usr, pwd);
            //System.out.println("Connection established");

            PreparedStatement ps = conn.prepareStatement("INSERT INTO Notes (text, user) VALUES (?,?)");
            ps.setString(1, note);
            ps.setInt(2, userId);
            ps.executeUpdate();

            /* BEWARE: Do not concat SQL queries, possible SQL injection
            Statement stmt = conn.createStatement();
            stmt.executeUpdate("INSERT INTO Notes (text, user) VALUES (\"" + note + "\","  + userId + ")");
            */

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

    private static void printNotes(int userId) {
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(url, usr, pwd);
            //System.out.println("Connection established");


            /* BEWARE: Do not concat SQL queries, possible SQL injection
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT notes.id id, notes.text text, notes.created created, users.name name " +
                    "FROM notes JOIN users ON users.id = notes.user " +
                    "WHERE users.id = " + userId +
                    " ORDER BY created ASC");
             */

            PreparedStatement ps = conn.prepareStatement("SELECT notes.id AS id, notes.text AS text, " +
                    "notes.created AS created, users.name AS name " +
                    "FROM notes JOIN users ON users.id = notes.user " +
                    "WHERE users.id = ? ORDER BY created ASC");
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()){
                int id = rs.getInt("id");
                String text = rs.getString("text");
                Date dateCreated = rs.getDate("created");
                Time timeCreated = rs.getTime("created");
                String name = rs.getString("name");

                System.out.println("note " + id + " from " + name + " at " + dateCreated.toString() + " " + timeCreated.toString() + ": " + text);
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

    private static int chooseUser() {
        Scanner sc = new Scanner(System.in);
        int userId = 0;
        printUsers();
        System.out.println("Please type user ID:");
        userId = sc.nextInt();
        return userId;
    }

    private static void printUsers() {
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(url, usr, pwd);
            //System.out.println("Connection established");

            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT id, name FROM users ORDER BY id ASC");

            while (rs.next()){
                int id = rs.getInt("id");
                String name = rs.getString("Name");
                System.out.println(name + " (ID " + id + ")");
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
