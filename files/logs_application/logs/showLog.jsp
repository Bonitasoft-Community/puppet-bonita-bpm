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
 
 version v03
 --%>
<%@page language="java"%>
<%@page import="java.io.*"%>
<%@page import="java.util.zip.GZIPInputStream"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
  <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
  <title>Bonita BPM Logs</title>
</head>
<body>
<%
String dirPath = application.getInitParameter("logsDirectory");
if (dirPath == null || dirPath.trim().length() == 0) {
  out.println("Initialization unsuccessful.");
  return;
}
File folder = new File(dirPath);

String logfileParameter = request.getParameter("logfile");
if (logfileParameter == null || logfileParameter.trim().length() == 0) {
  out.println("The parameter logfile is mandatory.");
  return;
}

File logfile = new File(folder, logfileParameter);
if (!logfile.exists() || !logfile.isFile() || !logfile.getParentFile().getCanonicalPath().startsWith(folder.getCanonicalPath())) {
  out.println("The requested log file " + logfileParameter + " does not exist.");
  return;
}

String logFileName = logfile.getName();
String lastThreeChar = logFileName.substring(logFileName.length() - 3);
BufferedReader reader;
if(lastThreeChar.equals(".gz")){
	InputStream fileStream = new FileInputStream(logfile);
	InputStream gzipStream = new GZIPInputStream(fileStream);
	String encoding = "UTF-8";
	Reader decoder = new InputStreamReader(gzipStream, encoding);
	reader = new BufferedReader(decoder);	
} else {
	reader = new BufferedReader(new FileReader(logfile));
}

String line;
while ((line=reader.readLine()) != null)  {
	out.println(line +"<br/>");
}
reader.close();
  
%>
</body>
</html>
