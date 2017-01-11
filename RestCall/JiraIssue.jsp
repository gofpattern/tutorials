<html>
<head>
<meta charset="UTF-8">
<script type="text/javascript">
	var childWindow = null;
	function child_open() {

		childWindow = window.open('JiraIssueLogin.jsp', "_blank",
				"resizable=no,width=600, height=280,top=200,left=200");

	}
	function parent_disable() {
		if (childWindow && !childWindow.closed)
			childWindow.focus();
	}
</script>
</head>
<body onclick="parent_disable();">
	<input type="button" value="Create Jira Ticket" onclick="child_open()" />
</body>
</html>

