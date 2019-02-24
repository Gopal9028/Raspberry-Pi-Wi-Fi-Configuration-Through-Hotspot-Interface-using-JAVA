<%@  page import="java.io.*,java.util.*"  language="java" contentType="text/html;" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<head>
		<meta http-equiv="Content-Type" content="text/html;">
		<meta http-equiv="content-type" content="text/html;">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>RPI_server</title>
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
	<body  class="watermark-bg" oncontextmenu="return false;">
        	<div id="contentWrapper">

				<div class="middle-box text-center loginscreen  animated fadeInLeft">
				    <form method="post">
						<div><img alt="image" class="m-t-xs img-responsive" src="img/logo.png"></div><br>
			            <h4>Login</h4>
						<div class="text-danger" id="ErrorMsg" style="display: none;">
							<span style="font-size: 13px;font-weight: 600;color: red;"><i class="fa fa-thumbs-o-down"></i>&nbsp;&nbsp;Invalid credentials</span>
						</div>
						</br>   
						<div class="form-group">
							<div class="control-group">
								<div class="controls">
									<div class="input-group m-b">
										<span class="input-group-addon">
											<i class="fa fa-user"></i>
										</span> 
										<input id="userLoginName" type="text" title="" class="form-control" value="" placeholder="Username" data-error-style="border" name="userName" required>
									</div>
								</div>
							 </div>
						</div>
						<div class="form-group">
							<div class="control-group">
								<div class="controls">
									<div class="input-group m-b">
										<span class="input-group-addon">
											<i class="fa fa-key"></i>
										</span> 
									<input id="password" type="password" class="form-control" value="" placeholder="password" data-error-style="border" name="password" required>
									</div>
								</div>
							 </div>
						</div>

						<button class="btn btn-primary block full-width m-b" id="submitAction">Login</button>
						<%
							ResourceBundle resource = ResourceBundle.getBundle("config");	
							String username = resource.getString("system_login");
							String password = resource.getString("system_password");
							
							if (request.getParameter("userName") != null) {
								if (request.getParameter("userName").equalsIgnoreCase(username)
										&& request.getParameter("password").equalsIgnoreCase(password)) {
									session.setAttribute("userName", username);
									response.sendRedirect("WiFiDetails.jsp");
								} else {
									out.print("<script>  document.getElementById('ErrorMsg').style.display = 'block';  </script>");
								}
							}
						%>		
					</form>					
				</div>
			</div>
	</body>
	<script>
		$(document).ready(function() {
			if($("#userLoginName").val()!=""){
				$("#password").focus();
			} else {
				$("#userLoginName").focus();
			}
		});
	</script>
</html>
