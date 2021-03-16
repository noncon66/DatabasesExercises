package com.Klaus.MyFirstDatabaseProgram;

import java.sql.*;


public class Main {
    public static void main(String[] args) {
        try {
            String url = "jdbc:mysql://localhost:3306/mondial";
            String usr = "klaus";
            String pwd = "avftEzYG7BWqd63";
            String query = "SELECT Country.Name, round(Population / Area, 2) PopDens " +
                    "FROM encompasses " +
                    "JOIN country ON encompasses.Country = Country.code " +
                    "WHERE encompasses.Continent = 'Asia' AND Percentage > 50 " +
                    "ORDER BY PopDens ASC " +
                    "LIMIT 10;";

            Connection connection = DriverManager.getConnection(url, usr, pwd);
            Statement stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            System.out.printf("%20s %10s%n",
                    "Name",
                    "PopDens");
            System.out.printf("%20s %10s%n",
                    "-".repeat(20),
                    "-".repeat(10));
            while (rs.next()) {
                System.out.printf("%20s %10.2f%n",
                        rs.getString("Name"),
                        rs.getFloat("PopDens"));
            }
        } catch (SQLException se) {
            se.printStackTrace();
        }
    }
}
