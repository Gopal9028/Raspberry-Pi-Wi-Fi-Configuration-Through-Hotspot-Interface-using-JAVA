<%@  page import="java.io.*,java.util.*,java.net.*"   language="java"  contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%
	 if ((session.getAttribute("userName") == null) || (session.getAttribute("userName") == "")) {
		 //No session valid so redirect to login
		 %><jsp:forward page="Welcome.jsp" /> <%
	 }

	//Read existing working SSID
	String workingSSIDLogin = null;
	FileInputStream inputStreamProperties = null;
	Properties prop = new Properties();
	//Read Properties 
	try {
		inputStreamProperties = new FileInputStream(session.getServletContext().getRealPath("/WEB-INF/classes/network.properties"));
		prop.load(inputStreamProperties);
		workingSSIDLogin =prop.getProperty("Temp_SSID_login");
		inputStreamProperties.close();
	} catch (Exception e) {
		%><%=e.toString()%><%
	} finally {
		if(inputStreamProperties != null){
			inputStreamProperties.close();
		}
	}
	
	boolean isNetWorking = false;
	if(workingSSIDLogin != null && (workingSSIDLogin.trim()).length() > 1) {
		//Check internet connectivity 
		 try {
			 URL url = new URL("http://www.google.com");
	         HttpURLConnection con = (HttpURLConnection) url.openConnection();
	         con.connect();
	         if (con.getResponseCode() == 200){
	        	 //Internet is working
	        	 isNetWorking = true;
	         } 
 		} catch (Exception e) {
 			//No internet 
	 	}
	}
	
	
	List<String> SSIDList = new ArrayList<String>(); 
	// Get Wifi SSID list
	Process p;
	try{ 
		ProcessBuilder pb = new ProcessBuilder("iw","dev","wlan0","scan");
		p = pb.start();
		int errCode = p.waitFor();
		BufferedReader reader = new BufferedReader(new InputStreamReader(p.getInputStream()));
		String line = "";			
		
		while ((line = reader.readLine())!= null) {
			if(line != null && line.contains("SSID")){
				SSIDList.add(line.replace("SSID: ",""));
			}
		}
	}catch(Exception e ){
		%></br>ERROR :: <%=e.toString()%><%
	}		

	//Get Bridge ID
	
	session.setAttribute("bridgeId","UTSA");
%>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>Rpi_server</title>
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
	<body class=" watermark-bg">
	   
		   <div id="contentWrapper" onload="noBack();" onpageshow="if (event.persisted) noBack();" onunload="">
				<div class="middle-box text-center loginscreen  animated fadeInLeft">
				    <form method="post">
			        <div>
						<span><small>Rpi wifi Settings</small></span>
						<div class="pull-right"><h3><%="UTSA"%></h3></div>
						</br> 
						
						<div>
			                <img alt="image" class="m-t-xs img-responsive" src="img/BDG.jpg"></br>
							<%
								String errorCode = request.getParameter("status");
								if(errorCode != null){
									%>
										<span style="font-size: 13px;font-weight: 600;color: red;padding: 6px 12px;position: absolute;top:48px;left: 15;"><i class="fa fa-thumbs-o-down"></i>&nbsp;&nbsp;incorrect </span>
										<span style="font-size: 14px;font-weight: 600;color: #ffffff;background-color: red;padding: 6px 12px;position: absolute;top: 186px;right: 22;"><i class="fa fa-wifi"></i>&nbsp;&nbsp;<%=workingSSIDLogin%></span>
										<tryagain/>
									<%
								}else {
									if(isNetWorking){
										%>
											<span style="font-size: 13px;font-weight: 600;color: #1ab394;padding: 6px 12px;position: absolute;top:48px;left: 15;"><i class="fa fa-thumbs-o-up"></i>&nbsp;&nbsp;connected</span>
											<span style="font-size: 14px;font-weight: 600;color: #ffffff;background-color: #1ab394;padding: 6px 12px;position: absolute;top: 186px;right: 22;"><i class="fa fa-wifi"></i>&nbsp;&nbsp;<%=workingSSIDLogin%></span>
										<%
									}else{
										%>
										<span style="font-size: 13px;font-weight: 600;color: red;padding: 6px 12px;position: absolute;top:48px;left: 15;"><i class="fa fa-thumbs-o-down"></i>&nbsp;&nbsp;notconnected</span>
										<%
									}									
									%><small><Enter wifi SSID"/><small><%
	
								}
							%>							
			            </div>					
			            <br>
			            
						<div class="form-group">
							<div class="control-group">
								<div class="controls">
									<div class="input-group m-b">
										<span class="input-group-addon">
											<i class="fa fa-wifi"></i>
										</span> 
										<%
											int count = SSIDList.size();
											if(count != 0){
										%>
											<select style="width:100%;" class="form-control" name="networkName">
											<option value="">Select wifi network</option>
	   									<% 
	   										for(String element: SSIDList){
	   										   if(element != null && ((element.trim()).length()) > 0){
	   									%>
   											<option value="<%=element%>"><%=element%></option>
   										<%
	   										   }
	   										  } 
   										%> 
   											</select>
										<%
											}else{
										%>  
									
					                    <input id="userLoginName" type="text" title="" class="form-control"  placeholder="n" data-error-style="border" name="networkName" required>
						                <%
						                	} 
						                %>
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
									<input id="password" type="password" class="form-control" value="" placeholder=password data-error-style="border" name="password" required>
									</div>
								</div>
							 </div>
						</div>
				                
		   
								<div class="text-danger" id="ErrorMsg1" style="display:none;">
								  	<h4> Try again</h4><br>
								</div> 								   
				                <button class="btn btn-primary block full-width m-b" id="submitAction">Configure</button>
					        </div>
					    </div>
					
					 	 <%
						  	String networkName=request.getParameter("networkName");
							String password=request.getParameter("password");
							
							if(networkName != null && password != null) {
								out.println("NetworkName : " + networkName);
								out.println("password : " + password);
								session.setAttribute("networkName", networkName);
								session.setAttribute("password", password);
								response.sendRedirect("SetWifi.jsp");
							}							
						%>
					</div>
				</div>
			</div>
		</form>
	 </body>
	<script>
		$(document).ready(function() {
			if($("#userLoginName").val()!="" || $("networkName").val()!="Select Wifi Network"){
				$("#password").focus();
			} else {
				$("#userLoginName").focus();
				$("#userLoginName").style.border = "2px solid red";
			}
		});
	</script>	 
</html>


