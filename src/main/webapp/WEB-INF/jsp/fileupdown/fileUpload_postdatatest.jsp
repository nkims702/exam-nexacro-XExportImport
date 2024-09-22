<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ page language="java"%>
<%@ page import="java.io.File"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.List"%>

<%@ page import="javax.servlet.ServletException"%>
<%@ page import="javax.servlet.http.HttpServletRequest"%>
<%@ page import="javax.servlet.http.HttpServletResponse"%>

<%--  cos.jar 다운로드   --%>
<%@ page import="com.oreilly.servlet.*"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>

<%@ page import="com.nexacro.java.xapi.tx.*" %>
<%@ page import="com.nexacro.java.xapi.tx.HttpPlatformResponse" %>
<%@ page import="com.nexacro.java.xapi.data.*" %> 
<%-- 
<%@ page import="com.nexacro17.xapi.tx.*" %>
<%@ page import="com.nexacro17.xapi.data.*" %>
--%>
<meta name="referrer" content="no-referrer" />
<!-- 출처: https://americanopeople.tistory.com/358 [복세편살:티스토리] -->
<%

	/*file upload*/
	
	request.setCharacterEncoding("UTF-8");
System.out.println("dir web-inf ----------------------------------------------------------------------");
	//서버의 실제 파일 저장 절대 경로
	String contextRealPath	= request.getSession().getServletContext().getRealPath("/");
	
	//파일이 저장될 위치 폴더
	String getFolderName	= request.getParameter("filefolder");
	
	
	String savePath = contextRealPath + getFolderName + "\\";
	
	//실제 url 주소(마지막 /로 부터 -18자리 - 자신의 환경에 맞게 조절해야 함)
	String url = request.getRequestURL().substring(0, request.getRequestURL().lastIndexOf("/")-18) + getFolderName + "/";
	
	int maxSize = 1000 * 1024 * 1024;
	System.out.println("dir web-inf maxSize ----------------------------------------------------------------------[" + maxSize + "]");
	File extFolder = new File(savePath);
	
	//퐇더가 없으면 생성
	if(!extFolder.exists())
	{
		extFolder.mkdir();
	}

	PlatformData resData = new PlatformData();
	VariableList resVarList = resData.getVariableList();

	try
	{
		MultipartRequest multi = new MultipartRequest(request, savePath, maxSize, "utf-8", new DefaultFileRenamePolicy());		
		Enumeration files = multi.getFileNames();
		

		//업로드 된 결과를 저장할 데이터셋 생성
		DataSet ds = new DataSet("ds_uploadresult");

		ds.addColumn(new ColumnHeader("fileName", DataTypes.STRING));		
		ds.addColumn(new ColumnHeader("fileSize", DataTypes.LONG));
		ds.addColumn(new ColumnHeader("fileType", DataTypes.STRING));
		ds.addColumn(new ColumnHeader("orgFileName", DataTypes.STRING));
		ds.addColumn(new ColumnHeader("savePath", DataTypes.STRING));
		ds.addColumn(new ColumnHeader("fullUrl", DataTypes.STRING));
		ds.addColumn(new ColumnHeader("fileid", DataTypes.STRING));
		
		while (files.hasMoreElements())
		{
			String name = (String)files.nextElement();			
			String fileName = multi.getFilesystemName(name);
			String oFileName = multi.getOriginalFileName(name);
			String type		= multi.getContentType(name);

			File f = multi.getFile(name);
			int row = ds.newRow(0);
			ds.set(row, "fileName", fileName);			
			ds.set(row, "fileType", type);
			ds.set(row, "orgFileName", oFileName);
			
			//파일이 있으면 경로, 크기, 저장된 주소를 저장합니다.
			if (f != null)
			{
				ds.set(row, "savePath", f.getPath());
				ds.set(row, "fileSize", f.length());
				ds.set(row, "fullUrl",  url+fileName);
			}
		}

		resData.addDataSet(ds);
		resVarList.add("ErrorCode", 0);
		resVarList.add("ErrorMsg", "Success" );
	}
	catch (Exception e)
	{
		System.out.println("WEB-INF fileUpload :::::::::::::::::::::::" + e.getMessage());
		DataSet dsError = new DataSet("ds_error");
		dsError.addColumn(new ColumnHeader("ErrorMsg", DataTypes.STRING));
		dsError.addColumn(new ColumnHeader("ErrorCode", DataTypes.LONG));

		dsError.set(dsError.newRow(), "ErrorCode", -1);
		dsError.set(dsError.newRow(), "ErrorMsg", e.getMessage());

		resData.addDataSet(dsError);
	}

	HttpPlatformResponse res = new HttpPlatformResponse(response, request);
	res.setContentType(PlatformType.CONTENT_TYPE_XML);
	res.setCharset("UTF-8");
	res.setData(resData);
	res.sendData();

%>
