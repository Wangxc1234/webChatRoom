package com.yxxy.weather;

import java.util.List;

import com.google.gson.Gson;

public class WeatherMessage {

	private String currTempture;
	private String currWind;
	private String currHum;	
	private String lifeLead;
	
	private List<everyWeather> eWeatherList;
	public static Gson gson = new Gson();
	

	public String toJson(){
		return gson.toJson(this);
	}

	public String getCurrTempture() {
		return currTempture;
	}

	public void setCurrTempture(String currTempture) {
		this.currTempture = currTempture;
	}

	public String getCurrWind() {
		return currWind;
	}

	public void setCurrWind(String currWind) {
		this.currWind = currWind;
	}

	public String getCurrHum() {
		return currHum;
	}

	public void setCurrHum(String currHum) {
		this.currHum = currHum;
	}

	public String getLifeLead() {
		return lifeLead;
	}

	public void setLifeLead(String lifeLead) {
		this.lifeLead = lifeLead;
	}

	public List<everyWeather> geteWeatherList() {
		return eWeatherList;
	}

	public void seteWeatherList(List<everyWeather> eWeatherList) {
		this.eWeatherList = eWeatherList;
	}

	
}
