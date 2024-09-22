package com.kims.nexacro;

import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.nexacro.java.xapi.tx.HttpPlatformResponse;

@Controller
public class NexacroApplicationTestController {
	
	@RequestMapping(value = "/xapitest", method = RequestMethod.POST)
	public String xapitest(Locale locale, @RequestBody Map<String,Object> param, HttpServletRequest request) {

//		ModelAndView modelAndView = new ModelAndView(new MappingJackson2JsonView());;
		System.out.println("-------------------------------------------------------------------------------------------");
		
//		HttpPlatformResponse
		
		
		System.out.println("-xapitest------------------------------------------------------------------------------------------");
		return "XapiTest";
	}

}
