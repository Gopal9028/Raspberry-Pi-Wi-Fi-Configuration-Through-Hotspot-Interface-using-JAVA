<%@  page import="java.io.*,java.util.*"   language="java"  contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
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
	<body  class=" watermark-bg" oncontextmenu="return false;">
			<div id="contentWrapper" onload="noBack();" onpageshow="if (event.persisted) noBack();" onunload="">
					<div class="middle-box text-center loginscreen  animated fadeInLeft">
						 <div><img alt="image" class="m-t-xs img-responsive" src="img/logo.png"></div><br>
						 	<div class="well">
						 		<div id="message">RPI restart</br></div>
						 	</div>
						 <div class="row">
							<div class="ibox float-e-margins">
								<div class="ibox-content">
									<table class="table">
										<thead>
										<tr>
											<th><small>colorled</small></th>
											<th><small>status</small></th>
										</tr>
										</thead>	
										<tbody>
										<tr>
											<td><img alt="yellow" class="btn-xs img-responsive" src="img/yellow.png"></td>
											<td><small>success</small></td>
										</tr>
										<tr>
											<td><img alt="red" class="btn-xs img-responsive" src="img/red.png"></td>
											<td><small>incorrect_password</small></td>
										</tr>
										</tbody>
									</table>
								</div>	
							</div>
						</div>
						
						<a href="WiFiDetails.jsp"><small>startover</small></a>
						<div class="pull-right"><span class="badge badge-primary"><div id="countdown">5</div></span></div>
                    </div>
                </div>
            </div>
						<%
						 if ((session.getAttribute("userName") == null) || (session.getAttribute("userName") == "")) {
							 response.sendRedirect("Welcome.jsp");	 
						 }else {
							 
								 //call Code to set wifi settings and restart bridge 
								String networkName = (String)session.getAttribute("networkName");
								String password = (String)session.getAttribute("password");								

								if(networkName != null){
									networkName = networkName.trim();
								}
								
								String command = "wpa_passphrase " + networkName + " " + password ;
								StringBuffer output = new StringBuffer();
								output.append("country=NL\n");
								output.append("ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev\n");
								output.append("update_config=0\n\n");

								// Set Wifi settings
								Process p;
								try{ 
									ProcessBuilder pb = new ProcessBuilder("wpa_passphrase", networkName, password);
									p = pb.start();
									int errCode = p.waitFor();
									BufferedReader reader = new BufferedReader(new InputStreamReader(p.getInputStream()));
									String line = "";			
									while ((line = reader.readLine())!= null) {
										output.append(line + "\n");
									}
								}catch(Exception e ){
									%></br>ERROR :: <%=e.toString()%><%
								}		
								try {
									File file = new File("/etc/wpa_supplicant/wpa_supplicant.conf");
									//File file = new File("c://test//file.txt");
									// if file doesnt exists, then create it
									if (!file.exists()) {
										file.createNewFile();
									}
									//Write to network file for wifi settings
									FileWriter fw = new FileWriter(file.getAbsoluteFile());
									BufferedWriter bw = new BufferedWriter(fw);
									bw.write(output.toString());
									bw.close();
		
								} catch (IOException e) {
									%></br>ERROR :: <%=e.toString()%><%
								}			
								
								//Store SSID and Login Temp before making it final, since we need to test internent connection.
								FileOutputStream outputStreamProperties = null;
								FileInputStream inputStreamProperties = null;
								Properties prop = new Properties();
								//Read Properties 
								try {
									inputStreamProperties = new FileInputStream(session.getServletContext().getRealPath("/WEB-INF/classes/network.properties"));
									prop.load(inputStreamProperties);
									inputStreamProperties.close();
					        	} catch (Exception e) {
					        		%><%=e.toString()%><%
					        	} finally {
					        		if(inputStreamProperties != null){
					        			inputStreamProperties.close();
					        		}
					        	}
																
				        		//Write Properties
								try {
									if(prop.isEmpty()){
										prop.setProperty("SSID_login", null);		
						        		prop.setProperty("SSID_password",null);
									}
					        		prop.setProperty("Temp_SSID_login", networkName);		
					        		prop.setProperty("Temp_SSID_password",password);
					        		session.setAttribute("networkName", networkName);
					        		outputStreamProperties = new FileOutputStream(session.getServletContext().getRealPath("/WEB-INF/classes/network.properties"));
					        		prop.store(outputStreamProperties,null);
					        		outputStreamProperties.close();
					        	} catch (Exception e) {
					        		%></br>ERROR :: <%=e.toString()%><%
					        	} finally {
					        		if(outputStreamProperties != null){
					        			outputStreamProperties.close();
					        		}
					        	}
						 }
						%>  
					</div>
				</div>
	</body>
	
	<script type="text/javascript">
	  var seconds;
	  var temp;
	 
	  function countdown() {
		seconds = document.getElementById('countdown').innerHTML;
		seconds = parseInt(seconds, 10);
	 
		if (seconds == 1) {
		  temp = document.getElementById('countdown');
		  temp.innerHTML = "<fmt:message key='login.data.restarting'/>";
		  document.location = "reboot.jsp";
		  return;
		}
	 
		if(seconds < 3 && seconds > 4){
			temp = document.getElementById('message');
			temp.innerHTML = "<div class='animated pulse'><fmt:message key='login.data.bridgerestart'/></div>";
		}
		
		if(seconds < 2 && seconds > 1){
			temp = document.getElementById('message');
			temp.innerHTML = "<div class='animated pulse'><fmt:message key='login.data.disapper'/></div>";
		}	 
		if(seconds < 1){
			temp = document.getElementById('message');
			temp.innerHTML = "<div class='animated pulse'><fmt:message key='login.data.bridgere'/></div>";
		}	
		seconds--;
		temp = document.getElementById('countdown');
		temp.innerHTML = seconds;
		timeoutMyOswego = setTimeout(countdown, 500);
	  } 
	 
	  countdown();
	</script>
</html>
