package com.andesa.afaswebconsole;

import java.awt.Desktop;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.Iterator;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

/**
 * @author ahafeez
 * 
 * @since Dec 27, 2016
 */
public class JiraRestServlet extends HttpServlet
{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(JiraRestServlet.class.getName());

	@SuppressWarnings("unchecked")
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException
	{
		String issueKey = null;
		URL url = new URL("http://app-atlas-dev:8080/jira/rest/api/2/issue/");

		try
		{
			// rest url for creation of issue
			
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setDoOutput(true);
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type", "application/json");
			conn.setRequestProperty("Authorization", "Basic " + req.getParameter("auth"));

			// build json object from request parameters to write to output stream

			JSONObject jsonWriter = new JSONObject();
			JSONObject projKey = new JSONObject();
			projKey.put("key",req.getParameter("product"));

			JSONObject issType = new JSONObject();
			issType.put("name", req.getParameter("issueType"));

			JSONObject fields = new JSONObject();
			fields.put("summary", " REST call "+req.getParameter("short_desc"));
			fields.put("project", projKey);
			fields.put("issuetype", issType);
			fields.put("customfield_10601", 0); //Account linked to the project,0 is for "None" account.
			fields.put("description", "Testing REST API\n"+req.getParameter("comment")); 
			jsonWriter.put("fields", fields);
			OutputStream os = conn.getOutputStream();
			os.write(jsonWriter.toString().getBytes());
			os.flush();
			if (conn.getResponseCode() != HttpURLConnection.HTTP_CREATED)
			{
				throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode()+" \n Json  data: "+ jsonWriter.toString()+"\n");
			}

			BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));

			StringBuffer output = new StringBuffer();
			String line;
			while ((line = br.readLine()) != null)
			{
				output.append(line);
			}

			// get the JIRA ticket number from the JIRA's json response
			JSONParser parser = new JSONParser();
			Object obj = parser.parse(output.toString());
			JSONObject jsonReader = (JSONObject) obj;
			for (Object key : jsonReader.keySet())
			{
				if ("key".equals(key))
					issueKey = (String) jsonReader.get(key);
			}

			conn.disconnect();

		} catch (MalformedURLException e)
		{

			e.printStackTrace();

		} catch (IOException e)
		{

			e.printStackTrace();

		} catch (ParseException e)
		{

			e.printStackTrace();
		}
		
		
		if (issueKey != null)
		{
			openIssueWindow(issueKey,url.toString());
			
		}

	}

	private void openIssueWindow(String issueKey, String url) throws IOException 
	{
		String issueURL = url+ issueKey;
		String os = System.getProperty("os.name").toLowerCase();
		Runtime rt = Runtime.getRuntime();

		if (os.indexOf("win") >= 0)
		{

			// this doesn't support showing urls in the form of "page.html#nameLink"
			rt.exec("rundll32 url.dll,FileProtocolHandler " + issueURL);

		} else if (os.indexOf("mac") >= 0)
		{

			rt.exec("open " + issueURL);

		} else if (os.indexOf("nix") >= 0 || os.indexOf("nux") >= 0)
		{

			// Do a best guess on unix until we get a platform independent way
			// Build a list of browsers to try, in this order.
			String[] browsers = { "epiphany", "firefox", "mozilla", "konqueror", "netscape", "opera", "links", "lynx" };

			// Build a command string which looks like "browser1 "url" || browser2 "url" ||..."
			StringBuffer cmd = new StringBuffer();
			for (int i = 0; i < browsers.length; i++)
				cmd.append((i == 0 ? "" : " || ") + browsers[i] + " \"" + issueURL + "\" ");

			rt.exec(new String[] { "sh", "-c", cmd.toString() });

		} else
		{
			return;
		}

	}

}
