package com.yxxy.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.rpc.ServiceException;

import com.yxxy.weather.WeatherMessage;
import com.yxxy.weather.everyWeather;

import cn.com.WebXml.WeatherWSLocator;
import cn.com.WebXml.WeatherWSSoap12Stub;

public class WeatherServlet extends HttpServlet {

	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		// TODO Auto-generated method stub

		req.setCharacterEncoding("utf-8");
		resp.setCharacterEncoding("utf-8");
		resp.setContentType("text/html;charset=utf-8");
		
		String weather = req.getParameter("weather");
		
		WeatherWSLocator wsLocator = new WeatherWSLocator();
		//当前天气
		WeatherMessage wMessage = new WeatherMessage();
		//预报5天
		List<everyWeather> eWeatherList = new ArrayList<everyWeather>();
		
		try {
			WeatherWSSoap12Stub wwStub = (WeatherWSSoap12Stub) wsLocator.getPort(WeatherWSSoap12Stub.class);
			
			String[] wArray = wwStub.getWeather(weather, "");
			if(wArray.length<= 1)
			{
				resp.getWriter().write("系统维护中，请稍后再试！");
				return;
			}
			//当前
			String current = wArray[4];
			String[] spiltArray = current.split("；");
			wMessage.setCurrTempture(spiltArray[0].substring(10));
			wMessage.setCurrWind(spiltArray[1].substring(6));
			wMessage.setCurrHum(spiltArray[2].substring(3));
			
			//生活指数
			wMessage.setLifeLead(wArray[6]);
			
			for (int i = 7; i < wArray.length; i++) {
				//resp.getWriter().print(wArray[i]+"<br>");
				//System.out.println(wArray[i]);
				everyWeather   eWeather = new everyWeather();
				eWeather.setDate(wArray[i]);
				eWeather.setTempture(wArray[i+1]);
				eWeather.setWind(wArray[i+2]);
				eWeather.setIcon1(wArray[i+3]);
				eWeather.setIcon2(wArray[i+4]);
				
				eWeatherList.add(eWeather);
				i += 4;
			}
			wMessage.seteWeatherList(eWeatherList);
			resp.getWriter().write(wMessage.toJson());
		} catch (ServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	
	}

}
