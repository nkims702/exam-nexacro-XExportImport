package com.kims.nexacro.config.security;

import javax.servlet.FilterChain;

import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.web.cors.CorsConfiguration;

/*@Configuration 
@EnableWebSecurity*/
public class Secuirty_Config /* extends WebSecurityConfigurerAdapter */{
	
	
	/*
	 * 
	 * https://samori.tistory.com/64
	 * https://velog.io/@choidongkuen/Spring-Security-Spring-Security-Filter-Chain-%EC%97%90-%EB%8C%80%ED%95%B4
	 * 
	 * 
Caused by: java.lang.IllegalStateException: Failed to introspect Class 
			[org.springframework.security.config.annotation.web.configuration.WebSecurityConfiguration] from ClassLoader [sun.misc.Launcher$AppClassLoader@58644d46]
	
	 * 
	 * 
	*/
	
//	@Override
//	protected void configure(HttpSecurity httpSecurity) throws Exception {
//		
//		//http.authorizeRequests().anyRequest().authenticated().and().csrf().ignoringAntMatchers("");
//		System.out.println("HttpSecurity configure **********************************************************************************");
//    	
//        httpSecurity.cors().configurationSource(request -> new CorsConfiguration().applyPermitDefaultValues());
//        // We don't need CSRF for this example
//      
//        httpSecurity.csrf()
//    	.disable();
//		
//		 
//	}
	
	/*
	 * @Override public void configure(WebSecurity web) throws Exception {
	 * 
	 * web.ignoring().antMatchers("/**"); }
	 */
	

}
