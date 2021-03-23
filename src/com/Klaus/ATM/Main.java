package com.Klaus.ATM;

import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.sql.*;
import java.util.Scanner;

//Daniels Ansatz: Dataenbank interaktionen auslagern in eigene Klasse
//Eigene Methode login (gibt Accountnumber zurück)


public class Main {
    private static final String url = "jdbc:mysql://localhost:3306/atm";
    private static final String usr = "java-user";
    private static final String pwd = "KVZmvv4Yjwo3";

    public static void main(String[] args) {

        while (true) {
            boolean exit = false;
            int accountnumber = 0;
            while (!exit) {

                boolean isValidAccount = false;

                Scanner sc = new Scanner(System.in);

                while (!isValidAccount) {

                    System.out.println("Insert Accountnumber:");
                    accountnumber = sc.nextInt();
                    System.out.println("PIN:");
                    int pin = sc.nextInt();

                    isValidAccount = checkAccount(accountnumber, pin);
                    if (isValidAccount)
                        System.out.println("Credentials correct");
                    else System.out.println("Credentials wrong, try again");
                }

                System.out.println("Account Balance: " + getAccountBalance(accountnumber));

                int type = askForAction(sc);
                if (type == 4) exit = true;
                while (type != 4) {

                    System.out.println("Insert amount:");
                    double amount = sc.nextDouble();
                    executeTransaction(type, amount, accountnumber);
                    type = askForAction(sc);

                }
                exportTransactionsCsv(accountnumber, "export.csv");
                System.out.println("Vielen Dank! Auf Wiedersehen!");
                System.out.println();

            }
        }
    }


    private static int askForAction(Scanner sc) {
        System.out.println("Choose Type:");
        System.out.println("1: withdrawl");
        System.out.println("2: deposit");
        System.out.println("3: export");
        System.out.println("4: exit");
        int type = sc.nextInt();
        return type;
    }

    private static void executeTransaction(int type, double amount, int accountnumber) {
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(url, usr, pwd);
            PreparedStatement ps = conn.prepareStatement("INSERT INTO transactions (amount, accountnumber) VALUES (?, ?)");
            if (type == 1) amount = amount * (-1);
            ps.setDouble(1, amount);
            ps.setInt(2, accountnumber);
            ps.executeUpdate();
            System.out.println("Transaction complete!");
            System.out.println("Account Balance: " + getAccountBalance(accountnumber));

        } catch (SQLException throwables) {
            throwables.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException se) {
                    se.printStackTrace();
                }
            }
        }
    }

    private static double getAccountBalance(int accountnumber) {
        Connection conn = null;
        double balance = 0;
        try {
            conn = DriverManager.getConnection(url, usr, pwd);
            PreparedStatement ps = conn.prepareStatement("SELECT balance FROM accountBalance WHERE accountnumber = ?");
            ps.setInt(1, accountnumber);
            ResultSet rs = ps.executeQuery();
            rs.next();
            balance = rs.getDouble("balance");

        } catch (SQLException throwables) {
            throwables.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException se) {
                    se.printStackTrace();
                }
            }
        }
        return balance;
    }

    private static boolean checkAccount(int accountnumber, int pin) {

        Connection conn = null;
        boolean isValid = false;
        ResultSet rs = null;
        try {

            conn = DriverManager.getConnection(url, usr, pwd);
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM accounts WHERE accountnumber = ? AND pinhash = SHA2(?,256)");
            ps.setInt(1, accountnumber);
            ps.setInt(2, pin);
            rs = ps.executeQuery();

            if (rs.next() == false) isValid = false;
            else isValid = true;

        } catch (SQLException throwables) {
            throwables.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException se) {
                    se.printStackTrace();
                }
            }
        }
        return isValid;
    }

    private static void exportTransactionsCsv(int accountnumber, String filename) {
        Connection conn = null;
        ResultSet rs = null;
        try {

            conn = DriverManager.getConnection(url, usr, pwd);
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM transactions WHERE accountnumber = ?");
            ps.setInt(1, accountnumber);
            rs = ps.executeQuery();
            var rsmd = rs.getMetaData();

            //header
            Writer writer = new FileWriter(filename);
            for (int i = 1; i <= rsmd.getColumnCount(); i++) {
                writer.append(rsmd.getColumnName(i));
                if (i != rsmd.getColumnCount()) {
                    writer.append(";");
                }
            }

            //body
            while (rs.next())
                for (int i = 1; i <= rsmd.getColumnCount(); i++) {
                    writer.append(rs.getString(i));
                    if (i != rsmd.getColumnCount()) {
                        writer.append(";");
                    }
                }


    } catch(SQLException |
    IOException throwables)

    {
        throwables.printStackTrace();
    } finally

    {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException se) {
                se.printStackTrace();
            }
        }
    }
}
}
