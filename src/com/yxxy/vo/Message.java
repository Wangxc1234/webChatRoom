package com.yxxy.vo;

import java.util.Date;
import java.text.SimpleDateFormat;
import java.util.List;

import com.google.gson.Gson;

public class Message {

	public String welcome;
	public List<String> usernames;
	//群聊
	public String contentUsername;
	public String contentMsg;
	public Integer type;
	//私聊
	public String fromPerson;
	public String toPerson;
	
	public static Gson gson = new Gson();
	
	public String toJson(){
		return gson.toJson(this);
	}

	public String getWelcome() {
		return welcome;
	}

	public void setWelcome(String welcome) {
		this.welcome = welcome;
	}

	
	public List<String> getUsernames() {
		return usernames;
	}

	public void setUsernames(List<String> usernames) {
		this.usernames = usernames;
	}

	public String getContentUsername() {
		return contentUsername;
	}

	public void setContentUsername(String contentUsername) {
		this.contentUsername = contentUsername;
	}

	public String getContentMsg() {
		return contentMsg;
	}

	public void setContentMsg(String contentMsg) {
		this.contentMsg = contentMsg;
	}

	public Integer getType() {
		return type;
	}

	public void setType(Integer type) {
		this.type = type;
	}

	public static Gson getGson() {
		return gson;
	}

	public static void setGson(Gson gson) {
		Message.gson = gson;
	}

	public String getFromPerson() {
		return fromPerson;
	}

	public void setFromPerson(String fromPerson) {
		this.fromPerson = fromPerson;
	}

	public String getToPerson() {
		return toPerson;
	}

	public void setToPerson(String toPerson) {
		this.toPerson = toPerson;
	}

}
