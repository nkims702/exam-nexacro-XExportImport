<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ page language="java"%>
<%@ page import="java.lang.String.*" %>
<%@ page import="java.util.zip.ZipOutputStream"%>
<%@ page import="java.util.zip.ZipEntry"%>
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

	/*download all files --> create zip file*/
	
	/*서버의 실제 파일 저장 절대 경로 */
	String contextRealPath = request.getSession().getServletContext().getRealPath("/");
	
	//넥사크로 플랫폼에서 전달한 폴더이름
	String getFolderName = request.getParameter("filefolder");
	
	//넥사크로 플랫폼에서 전달한 파일 이름 리스트
	String getNameList	 = request.getParameter("filenamelist");
	
	//","로 나열된 오브젝트를 나누어 배열로 만든다.
	String arrNameList[] = getNameList.split(",");

	ServletOutputStream out_stream	= null;
	BufferedInputStream in_stream	= null;
	
	//파일압축
	ZipOutputStream		zout_stream	= null;

	try
	{
		response.setContentType("application/octet;charset=utf-8");
		response.setHeader("Content-Disposition", "attachment; filename = \"" + getFolderName + ".zip" + "\"");
		
		out.clear();
		out = pageContext.pushBody();

		out_stream = response.getOutputStream();
		zout_stream = new ZipOutputStream(out_stream);
		zout_stream.setLevel(8);
		
		String filename = "";
		String filePath = "";
		
		for( int i = 0; i < arrNameList.length; i++ ){
			filename = new String(arrNameList[i].getBytes("iso8859-1"), "utf-8");
			filePath = contextRealPath + getFolderName + "\\" + filename;
			
			File fis = new File(filePath);
			in_stream = new BufferedInputStream(new FileInputStream(fis));
			
			ZipEntry zentry = new ZipEntry(filename);
			zentry.setTime(fis.lastModified());
			zout_stream.putNextEntry(zentry);
			
			byte[] buffer = new byte[1024];
			int n = 0;
			while ((n = in_stream.read(buffer, 0, 1024)) != -1)
			{
				zout_stream.write(buffer, 0, n);
			}
			
			zout_stream.closeEntry();	  
	  	}
		
	}
	catch (Exception e)
	{
		e.printStackTrace();
	}
	finally
	{
		if (zout_stream != null)
		{
			try
			{
				zout_stream.close();
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
		
	}
%>

