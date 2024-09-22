<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ page language="java"%>
<%@ page import="java.net.URLDecoder.*" %>
<%@ page import="java.io.BufferedInputStream"%>
<%@ page import="java.io.FileInputStream"%>
<%@ page import="java.io.File"%>
<%@ page import="java.io.IOException"%>
<%@ page import="javax.servlet.ServletException"%>
<%@ page import="javax.servlet.ServletOutputStream"%>
<%@ page import="javax.servlet.http.HttpServletRequest"%>
<%@ page import="javax.servlet.http.HttpServletResponse"%>

<%

	/*download single file*/
	
	/*서버의 실제 파일 저장 절대 경로 */
	String contextRealPath = request.getSession().getServletContext().getRealPath("/");

	//넥사크로 플랫폼에서 전달한 파일위치
	String getPath = request.getParameter("filepath");
	
	//넥사크로 플랫폼에서 전달한 파일이름
	String getName = request.getParameter("filename");
	
	//넥사크로 플랫폼에서 전달한 폴더이름
	String getFolderName = request.getParameter("filefolder");

	String filename = new String(getName.getBytes("iso8859-1"), "utf-8");
	String filePath = contextRealPath + getFolderName + "\\" + filename;
	
	byte[] buffer = new byte[1024];

	ServletOutputStream out_stream	= null;
	BufferedInputStream in_stream	= null;

	File fis = new File(filePath);

	if(fis.exists())
	{
		try
		{
			response.setContentType("application/octet;charset=utf-8");
			response.setHeader("Content-Disposition", "attachment; filename = \"" + filename + "\"");

			out.clear();
			out = pageContext.pushBody();

			out_stream = response.getOutputStream();
			in_stream = new BufferedInputStream(new FileInputStream(fis));

			int n = 0;
			while ((n = in_stream.read(buffer, 0, 1024)) != -1)
			{
				out_stream.write(buffer, 0, n);
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			if (in_stream != null)
			{
				try
				{
					in_stream.close();
				}
				catch (Exception e)
				{
					e.printStackTrace();
				}
			}
			if (out_stream != null)
			{
				try
				{
					out_stream.close();
				}
				catch (Exception e)
				{
					e.printStackTrace();
				}
			}
		}
	}
	else
	{
		System.out.println("fileDownload filename==>"+filename + ", 파일없음.");
		response.sendRedirect("unknownfile");
	}
%>

