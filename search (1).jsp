<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>     
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Search</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous"></script>
	<style>
     a { text-decoration : none; }
     a:visited { color: blue; }
    </style>
</head>
<body>
<%
String url="jdbc:mysql://localhost:3306/guestbook_d";
String user="root";
String password="";
Connection conn=DriverManager.getConnection(url,user,password);

//=======================
String search_target = request.getParameter("search_target");
out.println("검색대상은 "+search_target);

String search_word = request.getParameter("search_word");
search_word = "%" + search_word + "%";
//=======================
ResultSet rs=null;
PreparedStatement stmt = null;

if(search_target.equals("title_content")){//글제목+글내용 검색일경우
	stmt = conn.prepareStatement("SELECT * FROM guestbook_t WHERE title LIKE ? OR content LIKE ?");
	stmt.setString(1, search_word);
	stmt.setString(2, search_word);	
}
else if(search_target.equals("writer")){//글쓴이 검색일경우 
	stmt = conn.prepareStatement("SELECT * FROM guestbook_t WHERE writer LIKE ?");
	stmt.setString(1, search_word);
}
else if(search_target.equals("views")){//조회수 검색일경우
	
	int search_word1 = Integer.parseInt(request.getParameter("search_word1"));
	int search_word2 = Integer.parseInt(request.getParameter("search_word2"));
	//디버깅
	out.println("최소: "+ search_word1 + "최대: "+search_word2);
	
	stmt = conn.prepareStatement("SELECT * FROM guestbook_t WHERE views>=? AND views<=?");
	stmt.setInt(1, search_word1);
	stmt.setInt(2, search_word2);
}
rs = stmt.executeQuery();

//출력파트
out.println("<table class='table'><thead class='table-dark'>"+
"<tr><th scope='col'>글번호</th><th scope='col'>글제목</th><th scope='col'>글내용</th>"+
"<th scope='col'>글쓴이</th><th scope='col'>글쓴날짜</th><th scope='col'>조회수</th></tr></thead>");

out.println("<tbody class='table-group-divider'>");
while (rs.next()) { 
out.println("<tr>"); 
out.println("<td>"+rs.getString("no")+"</td>");
out.println("<td>"+rs.getString("title")+"</td>");
out.println("<td>"+rs.getString("content")+"</td>");
out.println("<td>"+rs.getString("writer")+"</td>");
out.println("<td>"+rs.getString("date")+"</td>");
out.println("<td>"+rs.getString("views")+"</td>");
out.println("</tr>");
} 
out.println("</tbody>");
out.println("</table>");

%>
</body>
</html>