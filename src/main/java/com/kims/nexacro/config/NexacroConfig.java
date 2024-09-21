package com.kims.nexacro.config;

import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;

import org.springframework.boot.autoconfigure.web.servlet.WebMvcRegistrations;
import org.springframework.boot.web.servlet.ServletContextInitializer;
import org.springframework.boot.web.servlet.ServletRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.HandlerMethodReturnValueHandler;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter;

import com.nexacro.java.xapi.tx.PlatformType;
import com.nexacro.java.xeni.services.GridExportImportServlet;
import com.nexacro.uiadapter.spring.core.context.ApplicationContextProvider;
import com.nexacro.uiadapter.spring.core.resolve.NexacroHandlerMethodReturnValueHandler;
import com.nexacro.uiadapter.spring.core.resolve.NexacroMappingExceptionResolver;
import com.nexacro.uiadapter.spring.core.resolve.NexacroMethodArgumentResolver;
import com.nexacro.uiadapter.spring.core.resolve.NexacroRequestMappingHandlerAdapter;
import com.nexacro.uiadapter.spring.core.view.NexacroFileView;
import com.nexacro.uiadapter.spring.core.view.NexacroView;

@Configuration
public class NexacroConfig extends WebAppConfig implements WebMvcRegistrations{
	
	@Bean
	public ApplicationContextProvider applicationContextProvider() {
		return new ApplicationContextProvider();
		
	}
	
	@Override
	public RequestMappingHandlerAdapter getRequestMappingHandlerAdapter() {
		return new NexacroRequestMappingHandlerAdapter();
	} 
	
	
	@Override
	public void addArgumentResolvers(List<HandlerMethodArgumentResolver> resolvers) {
//		super.addArgumentResolvers(resolvers);
		NexacroMethodArgumentResolver nexacroResolver = new NexacroMethodArgumentResolver();
		resolvers.add(nexacroResolver);
		super.addArgumentResolvers(resolvers);
	}
	
	@Override
	public void addReturnValueHandlers(List<HandlerMethodReturnValueHandler> handlers) {
		
		NexacroHandlerMethodReturnValueHandler returnValueHandler = new NexacroHandlerMethodReturnValueHandler();
		NexacroFileView nexacroFileView = new NexacroFileView();
		NexacroView nexacroView = new NexacroView();
		nexacroView.setDefaultContentType(PlatformType.CONTENT_TYPE_XML);
		nexacroView.setDefaultCharset("UTF-8");
		
		returnValueHandler.setView(nexacroView);
		returnValueHandler.setFileView(nexacroFileView);
		
		handlers.add(returnValueHandler);
		super.addReturnValueHandlers(handlers);
		//super.addReturnValueHandlers(handlers);
	}
	
	@Override
	public void configureHandlerExceptionResolvers(List<HandlerExceptionResolver> resolvers) {
		NexacroView nexacroView = new NexacroView();
		nexacroView.setDefaultContentType(PlatformType.CONTENT_TYPE_XML);
		nexacroView.setDefaultCharset("UTF-8");
		
		NexacroMappingExceptionResolver nexacroException = new NexacroMappingExceptionResolver();
		
		nexacroException.setView(nexacroView);
		nexacroException.setShouldLogStackTrace(true);
		nexacroException.setShouldSendStackTrace(true);
		nexacroException.setDefaultErrorMsg("fail.common.msg");
		//nexacroException.setMessageSource(messageSource());
		nexacroException.setOrder(1);
		resolvers.add(nexacroException);
		
		super.configureHandlerExceptionResolvers(resolvers);
		
		//	super.configureHandlerExceptionResolvers(resolvers);
	}
	
	@Bean
	  public ServletRegistrationBean<GridExportImportServlet> gridExportImportServletBean() {
	      ServletRegistrationBean<GridExportImportServlet> bean = 
	          new ServletRegistrationBean<GridExportImportServlet>( new GridExportImportServlet()
	              , "/XExportImport"
	              );
	      bean.setLoadOnStartup(1);
	      return bean;
	  }
	
	 @Bean
	 public ServletContextInitializer initializer() {

	      return new ServletContextInitializer() {
	        /*
	         * 넥사크로플랫폼 엑셀 처리 모듈:nexacro17-xeni.jar를 이용한 엑셀 처리 설정
	        */ 
	        @Override
	        public void onStartup(ServletContext servletContext) throws ServletException {
	                servletContext.setInitParameter("export-path"       , "file:///C:/Temp/export/");  //엑셀 export 임시폴더 생성 기준 디렉터리
	                servletContext.setInitParameter("import-path"       , "file:///C:/Temp/import/");  //엑셀 import 임시폴더 생성 기준 디렉터리
	                servletContext.setInitParameter("monitor-enabled"   , "true");    //임시파일 삭제를 위한 모니터링 여부
	                servletContext.setInitParameter("monitor-cycle-time", "30");      //임시파일 삭제를 위한 모니터링 주기( default:분)
	                servletContext.setInitParameter("file-storage-time" , "10");      //임시파일 생성 디렉터리 모니터링 주기 (default:분)
	        }
	      };
	  }
	
	
}
