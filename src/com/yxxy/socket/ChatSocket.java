package com.yxxy.socket;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import com.google.gson.Gson;
import com.yxxy.vo.Content;
import com.yxxy.vo.Message;

@ServerEndpoint("/chatSocket")
public class ChatSocket {

	private String username;
	private static List<Session> sessions = new ArrayList<Session>();
	private static List<String> names = new ArrayList<String>();
	private static Map<String, Session> map = new HashMap<String, Session>();// 广播还是私聊
	
	//获取登录信息，并加入到用户列表
	@OnOpen
	public void open(Session session)
	{
		String queryString = session.getQueryString();
		try {
			String querystr = URLDecoder.decode(queryString, "utf-8");
		

			username = querystr.split("=")[1];
			
			sessions.add(session);
			names.add(username);
			map.put(username, session);
			
						
			String msg = " 系统消息：  欢迎  "+username+"  进入聊天室！";
			
			Message message = new Message();
			message.setUsernames(names);
			message.setWelcome(msg);
			
			broadcase(sessions, message.toJson());
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	/**
	 * 离开聊天室
	 */
	@OnClose
	public void close(Session session) {
		sessions.remove(session);
		names.remove(username);
		map.remove(username);
		
		String msg =  " 系统消息：  "+username + "离开聊天室！";
		
		Message message = new Message();
		message.setUsernames(names);
		message.setWelcome(msg);
		
		broadcase(sessions, message.toJson());
	}
//发送广播
	private void broadcase(List<Session> sessions, String msg) {
		// TODO Auto-generated method stub
		for (Iterator iterator = sessions.iterator(); iterator.hasNext();) {
			Session session = (Session) iterator.next();
			
			try {
				session.getBasicRemote().sendText(msg);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	
	//群发
	@OnMessage
	public void message(Session session,String json)
	{
		Gson gson = new Gson();
		Content content  = gson.fromJson(json, Content.class);
		
		//广播
		if(content.getType()==1)
		{
			Message message = new Message();
			message.setContentUsername(username);
			message.setContentMsg(content.getMsg());
			message.setType(1);
			
			broadcase(sessions, message.toJson());
		}
		//私聊
		else{
			String to = content.getTo();	//要发给的对象
			Session from_session = map.get(username);	//自己的session
			Session to_session = map.get(to);	//接收人的session
			try {
				//判断对方是否在线
				if(to_session == null)
				{	
					String msg =  " 系统消息：  "+to+ "离开聊天室！";
					
					Message message = new Message();				
					message.setWelcome(msg);
					message.setFromPerson(username);
					message.setToPerson(to);
					message.setType(2);
					from_session.getBasicRemote().sendText(message.toJson());//自己对别人说
					return;
				}
				
				Message message = new Message();	
				message.setContentMsg(content.getMsg());
				message.setToPerson(to);
				message.setFromPerson(username);
				message.setType(2);
				
				
				from_session.getBasicRemote().sendText(message.toJson());//自己对别人说
				to_session.getBasicRemote().sendText(message.toJson());//别人对我说
			} catch (IOException e) {
				e.printStackTrace();
			}
			
		}
	}

}
