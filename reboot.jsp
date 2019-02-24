<%@  page import="java.io.*,java.util.*"   language="java"  contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<meta http-equiv="content-type" content="text/html; charset=UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>Rpi:restarting</title>
		<link rel="shortcut icon" type="image/x-icon" href="img/favicon.ico">
		<link href="css/bootstrap.min.css" rel="stylesheet">
		<link href="font-awesome/css/font-awesome.min.css" rel="stylesheet">
		<link href="css/animate.css" rel="stylesheet">
		<link href="font-awesome/css/goolefont.css" rel="stylesheet">
		<link href="font-awesome/css/goolefontone.css" rel="stylesheet">
		<link href="css/style.min.css" rel="stylesheet">
		<link href="css/custom.css" rel="stylesheet">
		<link href="css/login.css" rel="stylesheet">
		<script type="text/javascript" src="js/jquery-1.10.2.js"></script> 
	</head>
	<body  class=" watermark-bg" oncontextmenu="return false;">
			<div id="contentWrapper" onload="noBack();" onpageshow="if (event.persisted) noBack();" onunload="">
					<div class="middle-box text-center loginscreen  animated fadeInLeft">
				 <div><img alt="image" class="m-t-xs img-responsive" src="img/logo.png"></div><br>
				<div class="row">
					<div class="ibox float-e-margins">
						<div class="ibox-title">
							<h5>disapper</h5>
						</div>
						<div class="ibox-content">
							<div>restarting</div>
						</div>
					</div>
				</div>
				<a href="WiFiDetails.jsp"><small>startover</small></a>
			</div>
		</div>
		<%
		 if ((session.getAttribute("userName") == null) || (session.getAttribute("userName") == "")) {
			 response.sendRedirect("Welcome.jsp");	 
		 }else {
 			try {
				//Reboot
				String command ="sudo reboot";
				Process p = Runtime.getRuntime().exec(command);
				//p.waitFor();				
			} catch (IOException e) {
				e.printStackTrace();
			}					
 		 }
		%>  		
	</body>
	<script>
	  setTimeout(function() {
		  document.location = "CheckInternetConn.jsp?language="+"${sessionScope.language}"+"&bridgeId="+"${sessionScope.bridgeId}"+"&networkName="+"${sessionScope.networkName}";
	  }, 10000); // <-- this is the delay in milliseconds
	</script>	
</html>
