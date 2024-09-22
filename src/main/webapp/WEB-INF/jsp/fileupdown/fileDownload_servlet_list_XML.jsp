<%@ page import = "java.io.*" %>
<%@ page import = "java.util.*" %>

<%@ page import="com.nexacro.java.xapi.tx.*" %>
<%@ page import="com.nexacro.java.xapi.tx.HttpPlatformResponse" %>
<%@ page import="com.nexacro.java.xapi.data.*" %> 
<%-- 
<%@ page import="com.nexacro17.xapi.tx.*" %>
<%@ page import="com.nexacro17.xapi.data.*" %>
<%@ page import="com.nexacro17.xapi.data.datatype.*" %>
--%>
<%

	/*upload file List (search)*/
	
	String strCharset = "utf-8";

	PlatformRequest platformRequest = new PlatformRequest(request.getInputStream(), PlatformType.CONTENT_TYPE_XML, strCharset);
	platformRequest.receiveData();
	PlatformData inPD = platformRequest.getData();
	VariableList inVariableList  = inPD.getVariableList();

	PlatformData resData = new PlatformData();
	VariableList resVarList = resData.getVariableList();
	
	String folderName = inVariableList.getString("filefolder");
	
	
	/*서버의 실제 파일 저장 절대 경로 */
	String filePath = request.getRealPath("./" + folderName) + "/";
	
	//실제 url 주소(마지막 /로 부터 -18자리 - 자신의 환경에 맞게 조절해야 함)
	String url = request.getRequestURL().substring(0, request.getRequestURL().lastIndexOf("/")-18) + folderName + "/";

	//output dataset
	DataSet ds = new DataSet("dsList");
	ds.addColumn("FILE_NAME", DataTypes.STRING, 255);
	ds.addColumn("FILE_URL", DataTypes.STRING, 255);
	ds.addColumn("FiLE_SIZE", DataTypes.STRING, 255);
	int row;

	File rf = new File(filePath); 
	File[] rfiles = rf.listFiles();
	
	if(rfiles != null)
	{
		for(int i=0; i<rfiles.length; i++)
		{
			if(rfiles[i].isFile())
			{
				//file name, url, size dataset row에 저장
				row = ds.newRow();
				ds.set(row, "FILE_NAME", rfiles[i].getName());
				ds.set(row, "FILE_URL", url + rfiles[i].getName());
				ds.set(row, "FiLE_SIZE", rfiles[i].length());
			}
		}
	}
	else
	{
		//file is empty
		System.out.println("rfiles is null");
	}

	resData.addDataSet(ds);
	resVarList.add("ErrorCode", 0);
	resVarList.add("ErrorMsg", "Success" );
		
	HttpPlatformResponse pRes = new HttpPlatformResponse(response, request);
	pRes.setContentType(PlatformType.CONTENT_TYPE_XML);
	pRes.setCharset("UTF-8");
	pRes.setData(resData);
	pRes.sendData();
%>
