package com.Klaus.ModialDatabase;

import java.sql.*;

public class DynColumns {
    private static final String url = "jdbc:mysql://localhost:3306/mondial";
    private static final String usr = "java-user";
    private static final String pwd = "KVZmvv4Yjwo3";

    private static String sqlQuery_1 =
            "select Country.Name, round(Population / Area, 2) PopDens " +
                    "from encompasses " +
                    "join country on encompasses.Country = Country.code " +
                    "where encompasses.Continent = 'Asia' and Percentage > 50 " +
                    "order by PopDens ASC " +
                    "limit 10;";
    private static String sqlQuery_2 = "select * from province LIMIT 10;";


    public static void main(String[] args) {
        try {


            Connection conn = DriverManager.getConnection(url, usr, pwd);
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sqlQuery_2);

            printResult(rs);
        } catch (SQLException se) {
            se.printStackTrace();
        }
    }

    public static void printResult(ResultSet rs) throws SQLException {
        ResultSetMetaData md = rs.getMetaData();

        for (int i = 1; i <= md.getColumnCount(); i++) {
            //System.out.printf("%20s %20s %5d %10s %5d%n", md.getColumnLabel(i), md.getColumnName(i), md.getColumnDisplaySize(i), md.getColumnTypeName(i), md.getColumnType(i));
            if (md.getColumnType(i) == Types.VARCHAR){
                System.out.printf("%-" + Math.max(md.getColumnDisplaySize(i), md.getColumnLabel(i).length()) + "s |", md.getColumnLabel(i));
            } else {
                System.out.printf("%" + Math.max(md.getColumnDisplaySize(i), md.getColumnLabel(i).length()) + "s |", md.getColumnLabel(i));
            }
        }
        System.out.println();
        for (int i = 1; i <= md.getColumnCount(); i++) {
            System.out.printf("%s |", "-".repeat(Math.max(md.getColumnDisplaySize(i), md.getColumnLabel(i).length())));
        }
        System.out.println();

        while (rs.next()) {
            for (int i = 1; i <= md.getColumnCount(); i++) {
                if (md.getColumnType(i) == Types.VARCHAR){
                    System.out.printf("%-" + Math.max(md.getColumnDisplaySize(i), md.getColumnLabel(i).length()) + "s |", rs.getString(i));
                } else {
                    System.out.printf("%" + Math.max(md.getColumnDisplaySize(i), md.getColumnLabel(i).length()) + "s |", rs.getString(i));
                }

                //System.out.printf("%20s %20s %5d %10s %5d%n", md.getColumnLabel(i), md.getColumnName(i), md.getColumnDisplaySize(i), md.getColumnTypeName(i), md.getColumnType(i));
            }
            System.out.println();
        }
    }


}
