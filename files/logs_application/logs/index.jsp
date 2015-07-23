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

 F.Krebs : version v04
 
 --%>
 
<%@page language="java"%>
<%@page import="java.io.*"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.text.DecimalFormat" %>
<%@page import="java.text.SimpleDateFormat" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
  <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
  <title>Bonita BPM Logs</title>
  
  <link rel="stylesheet" href="resources/themes/bonitasoft/style.css" type="text/css" />
  
  <script type="text/javascript" src="resources/js/jquery-latest.js"></script>
  <script type="text/javascript" src="resources/js/jquery.tablesorter.min.js"></script>  
  
</head>
<body>
<div id="header">
	<h1>Bonita BPM logs - <%=request.getServerName() %></h1>
</div>

<p id="tip">TIP! Sort multiple columns simultaneously by holding down the shift key and clicking a second, third or even fourth column header! </p>

<table id="logTable" class="tableSorter">
	<thead> 
		<tr>
			<th>File name</th>
			<th>Component</th>
			<th>Last modified date</th>
			<th>Last modified time</th>
			<th>Size</th>		
			<th>View</th>
			<th>Download</th>
		</tr>
	</thead> 
	<tbody> 	
	
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
	//  Input Filename format: Component.Date.Extension
	String filename = fileEntry.getName();
	String[] filenameArray = filename.split("\\."); 
	String component = filenameArray[0];	

	//Size
	String fileSize;
	int digitGroups;

	long size = fileEntry.length();
	if(size <= 0){ 
		fileSize = "0";
	} else {	
		String[] units = new String[] { "B", "kB", "MB", "GB", "TB" };	
		digitGroups = (int) (Math.log10(size)/Math.log10(1024));
		fileSize = new DecimalFormat("#,##0.#").format(size/Math.pow(1024, digitGroups)) + " " + units[digitGroups];
	}

	//Date and Time
	SimpleDateFormat sdfTime = new SimpleDateFormat("HH:mm:ss");
	String lastModifyTime = sdfTime.format(fileEntry.lastModified());
	
	SimpleDateFormat sdfDate = new SimpleDateFormat("YYYY-MM-dd");
	String lastModifyDate = sdfDate.format(fileEntry.lastModified());

   
%>
		<tr>
			<td>
				<%=filename%> 
			</td>
			
			<td>
				<%=component%> 
			</td>

			<td>
				<%=lastModifyDate%> 
			</td>	

			<td>
				<%=lastModifyTime%>
			</td>
			
			<td>
				<%=fileSize%>
			</td>				


			<td>
				<a href="showLog.jsp?logfile=<%=filename%>">View</a> 
			</td>

			<td>
				<a href="DownloadLogFileServlet?logfile=<%=filename%>">Download</a>
			</td>
		</tr>
<%
}
%>
	</tbody> 
</table>
</body>

<script type="text/javascript">
	<!-- Start by telling tablesorter to sort your table when the document is loaded -->
	$(document).ready(function() 
		{ 
			$("#logTable").tablesorter(); 
		} 
	); 

</script>

</html>
