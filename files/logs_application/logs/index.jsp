<%-- Copyright (C) 2009 BonitaSoft S.A.
 BonitaSoft, 31 rue Gustave Eiffel - 38000 Grenoble
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 2.0 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>. 
 
 Version : v03
 
 --%>
<%@page language="java"%>
<%@page import="java.io.*"%>
<%@page import="java.util.Arrays"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
  <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
  <title>Bonita BPM Logs</title>
</head>
<body>
<ul>
<%
String dirPath = application.getInitParameter("logsDirectory");
if (dirPath == null || dirPath.trim().length() == 0) {
  out.println("Initialization unsuccessful.");
  return;
}
File folder = new File(dirPath);
File[] files = folder.listFiles();
Arrays.sort(files);
for (final File fileEntry : files) {
   String filename = fileEntry.getName();
%>
  <li><a href="showLog.jsp?logfile=<%=filename%>"><%=filename%></li>
<%
}
%>
</ul>
</body>
</html>
