package com.kims.nexacro.config;

import java.util.List;

import org.springframework.boot.autoconfigure.web.servlet.WebMvcRegistrations;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.HandlerMethodReturnValueHandler;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter;

import com.nexacro.java.xapi.tx.PlatformType;
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
		nexacroException.setDefaultErrorMsg("err.agent.fail.excute.command");
		//nexacroException.setMessageSource(messageSource());
		nexacroException.setOrder(1);
		resolvers.add(nexacroException);
		
		super.configureHandlerExceptionResolvers(resolvers);
		
		//	super.configureHandlerExceptionResolvers(resolvers);
	}
	
	
	
}
