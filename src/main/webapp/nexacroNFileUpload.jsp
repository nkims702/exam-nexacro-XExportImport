<%@ page contentType="text/xml; charset=UTF-8" %>

<%@ page import = "java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import = "javax.servlet.http.*" %>
<%@ page import = "org.apache.commons.fileupload.*" %>
<%@ page import = "org.apache.commons.fileupload.disk.*" %>
<%@ page import = "org.apache.commons.fileupload.servlet.*" %>
<%@ page import = "org.apache.commons.io.output.*" %>
<%@ page import="com.nexacro.java.xapi.tx.*" %>
<%@ page import="com.nexacro.java.xapi.tx.HttpPlatformResponse" %>
<%@ page import="com.nexacro.java.xapi.data.*" %> 
<%
// 버퍼(buffer) 초기화
out.clearBuffer();

// HttpPlatformRequest 생성
HttpPlatformRequest req = new HttpPlatformRequest(request.getInputStream());
// byte 배열 데이터를 파일로 저장하기 위한 DataTypeChanger 설정
req.setDataTypeChanger(new UploadDataTypeChanger());

// 데이터 수신
req.receiveData();

// 수신된 데이터 참조
PlatformData reqData = req.getData();

// 임시로 저장된 파일들을 업로드될 위치로 이동
copyFiles(reqData);

// 송신 데이터 생성
PlatformData resData = new PlatformData();
VariableList resVl = resData.getVariableList();

// 오류코드 설정
resVl.add("ERROR_CODE", "200");

// HttpPlatformResponse 생성
HttpPlatformResponse res = new HttpPlatformResponse(response.getOutputStream(), req);
// 송신 데이터 설정
res.setData(resData);

// 데이터 송신
res.sendData();
%>

<%!
// 임시로 저장된 파일들을 업로드될 위치로 이동
void copyFiles(PlatformData data) {
  // 파일들이 업로드될 위치
  String dir = "C:\\upload";
  // 파일 데이터가 저장된 DataSet 참조
  DataSet ds = data.getDataSet("resources");
  // DataSet의 행(row)의 갯수 참조
  int count = (ds == null) ? 0 : ds.getRowCount();
  
  // DataSet의 행(row)의 갯수, 즉 업로드된 파일의 갯수만큼 순환
  for (int i = 0; i < count; i++) {
    // 파일명 참조
    String name = ds.getString(i, "name");
    // 파일크기 참조
    int size = ds.getInt(i, "size");
    // 파일의 변경시간 참조
    long lastWriteTime = ds.getLong(i, "lastWriteTime");
    // 임시로 저장된 파일의 경로 참조
    String filename = ds.getString(i, "content");
  
    // 임시로 저장된 File
    File file = new File(filename);
    // 업로드될 위치로 이동할 File
    File dest = new File(dir, name);
  
    // 파일 이동
    file.renameTo(dest);
  }
}

// 수신 받은 DataSet 열(column)의 데이터 형식(dataType)을 변경하는 DataTypeChanger
class UploadDataTypeChanger implements DataTypeChanger {

  // byte 배열의 데이터가 저장된 DataSet 열(column)의 데이터 형식(dataType)을 DataTypes.FILE 데이터 형식(dataType)으로 변경
  // 수신 받는 데이터의 데이터 형식(dataType)을 DataTypes.FILE 데이터 형식(dataType)으로 변경하는 경우
  // 데이터는 자동으로 임시 파일로 저장되고, DataSet에는 저장된 임시 파일의 경로가 저장된다.
  public int getDataType(String dsName, String columnName, int dataType) {
    // "resources" DataSet의 "content" 열(column)인 경우 DataTypes.FILE 데이터 형식(dataType) 반환
    if ("resources".equals(dsName) && "content".equals(columnName)) {
      return DataTypes.FILE;
    }

    // 이외에는 원 데이터 형식(dataType) 반환
    return dataType;
  }
}
%>

