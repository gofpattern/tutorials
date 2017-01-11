
<html>
<head>
<meta charset="UTF-8">
<link href="AWC.css" rel="stylesheet" type="text/css">
<style>
label {
	display: inline-block;
	width: 160px;
	text-align: right;
}
​
</style>
<script type="text/javascript">
	var count = 0;
	// Create Base64 Object
	var Base64={_keyStr:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",encode:function(e){var t="";var n,r,i,s,o,u,a;var f=0;e=Base64._utf8_encode(e);while(f<e.length){n=e.charCodeAt(f++);r=e.charCodeAt(f++);i=e.charCodeAt(f++);s=n>>2;o=(n&3)<<4|r>>4;u=(r&15)<<2|i>>6;a=i&63;if(isNaN(r)){u=a=64}else if(isNaN(i)){a=64}t=t+this._keyStr.charAt(s)+this._keyStr.charAt(o)+this._keyStr.charAt(u)+this._keyStr.charAt(a)}return t},decode:function(e){var t="";var n,r,i;var s,o,u,a;var f=0;e=e.replace(/[^A-Za-z0-9\+\/\=]/g,"");while(f<e.length){s=this._keyStr.indexOf(e.charAt(f++));o=this._keyStr.indexOf(e.charAt(f++));u=this._keyStr.indexOf(e.charAt(f++));a=this._keyStr.indexOf(e.charAt(f++));n=s<<2|o>>4;r=(o&15)<<4|u>>2;i=(u&3)<<6|a;t=t+String.fromCharCode(n);if(u!=64){t=t+String.fromCharCode(r)}if(a!=64){t=t+String.fromCharCode(i)}}t=Base64._utf8_decode(t);return t},_utf8_encode:function(e){e=e.replace(/\r\n/g,"\n");var t="";for(var n=0;n<e.length;n++){var r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r)}else if(r>127&&r<2048){t+=String.fromCharCode(r>>6|192);t+=String.fromCharCode(r&63|128)}else{t+=String.fromCharCode(r>>12|224);t+=String.fromCharCode(r>>6&63|128);t+=String.fromCharCode(r&63|128)}}return t},_utf8_decode:function(e){var t="";var n=0;var r=c1=c2=0;while(n<e.length){r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r);n++}else if(r>191&&r<224){c2=e.charCodeAt(n+1);t+=String.fromCharCode((r&31)<<6|c2&63);n+=2}else{c2=e.charCodeAt(n+1);c3=e.charCodeAt(n+2);t+=String.fromCharCode((r&15)<<12|(c2&63)<<6|c3&63);n+=3}}return t}}
	function submit_and_close() {
		
		var form = document.forms['auth_form'];
		var auth = document.createElement("input");
		auth.name = "auth";
		auth.type = "hidden";
		var authValue = form.elements['username'].value+ ":"+ form.elements['password'].value;
		
		// Encode for authentication
		auth.value = Base64.encode(authValue);
		form.appendChild(auth);
		var issuedata = window.opener.document.forms['Create'].querySelectorAll('input');
		 for (var i = 0; i < issuedata.length; i++) {
			 var data = issuedata[i];
			 if(data.type !== "submit")
			 form.appendChild(data);	 
         }

		form.submit();
		// close the window after form submission is complete.
		var docLoaded = setInterval(function() {

			if (document.readyState !== "complete") {

				return;
			}
			clearInterval(docLoaded);
			//window.close();
		}, 30);

	}
</script>
</head>
<body>
	<div class="pageheader_custom">
		<h1>JIRA Credentials and Issue Type</h1>
		<br>
		<form name="auth_form" id="auth_form" method="post" action="JiraRest">
			<label> User Name: </label> <input type="text" name="username"><br>
			<label> Password: </label> <input type="password" name="password"><br>
			<label for="issueType">Select Issue Type</label> 
			<select id="issueType" name="issueType">
				<option value="Beeper Call">Beeper Call</option>
				<option value="Research">Research</option>
				<option value="Defect">Defect</option>
				<option value="Hot Fix">Hot Fix</option>
				<option value="Release">Release</option>
				<option value="T &M">T &M</option>
				<option value="External ID Request">External ID Request</option>
				<option value="Administrative Task">Administrative Task</option>
				<option value="Epic">Epic</option>
				<option value="New Feature">New Feature</option>
				<option value="Bug">Bug</option>
				<option value="Outage">Outage</option>
				<option value="Improvement">Improvement</option>
				<option value="Project Administration">ProjectAdministration</option>
				<option value="ProjDevelopment">ProjDevelopment</option>
				<option value="ProjDefect">ProjDefect</option>
				<option value="Task">Task</option>
				<option value="Story">Story</option>
				<option value="ProjResearch">ProjResearch</option>
				<option value="Enhancement">Enhancement</option>
				<option value="Standard Spur">Standard Spur</option>
				
			</select> <input type="button" value="Log In" onclick="submit_and_close()">
		</form>

	</div>
</body>
</html>