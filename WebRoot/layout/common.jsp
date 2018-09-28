<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<head>
	<script type="text/javascript" src="js/jquery-easyui-1.6.3/jquery.min.js"></script>
	<script type="text/javascript" src="js/jquery-easyui-1.6.3/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="js/jquery-easyui-1.6.3/locale/easyui-lang-zh_CN.js"></script>
	
	<style type="text/css">		
		.left{
			margin-left:40px;
	</style>
	<script type="text/javascript">
	
			//获取父页面websocket对象
			var ws;
			//获取本人username
			var username = parent.username;
			//为msg输入框重新设置id
			var msgId;
			//获取本页面的title
			var strTitle;
			
		window.onload = function(){	
			ws = window.parent.ws;//获取主页面的websocket对象			
			
			var tab = parent.$('#layout_center_centerTabs').tabs('getSelected');
			var title = tab.panel('options').title;		//获取本页面的title
			var index = tab.panel('options').index;		//获取本页面的index
			strTitle= ""+title.toString();
			
			//获取子框架文档对象
			var doc = parent.document.getElementById(strTitle).contentDocument || parent.document.frames[strTitle].document;
			
			var newId = strTitle+"_"+index; 
			//重新设置div的id为tab页title+索引
			doc.getElementById('person').id=newId;
			
			//为msg输入框重新设置id
			 msgId = "msg_"+index;
			doc.getElementById('msgPerson').id=msgId;
			 
			// 增加Ctrl+回车提交功能
			$("#"+msgId).keypress(function (event){
			     if (event.ctrlKey && event.keyCode == 13||event.keyCode == 10)  {
			        subPersonSend();
			    }
			});			
		
		};
		
		function subPersonSend() {
		
			var msg = $("#"+msgId).val();
			if(msg==""||msg.trim()==""){
				$("#"+msgId).val("");
				return;
			}
			
			$("#"+msgId).val("");
			
			obj = {
				to: strTitle,
				msg: msg,
				type: 2// 私聊
			}
			// 返回后台json格式字符串
			var json = JSON.stringify(obj);
			ws.send(json);	
			
		}
		
		function sendMouseOver(obj){
			obj.style.backgroundColor='green';
			obj.style.color='white';
		}
		function sendMouseOut(obj){
			obj.style.backgroundColor='white';
			obj.style.color='';
		}
		
</script>		
</head>

	<div id="person" style="overflow-y: auto;height:82%;"></div>
	<div style=" border-radius: 4px; box-shadow:inset 0 10px 0 0 #ccc;">
 		<textarea id="msgPerson" style="border-style:none;width:100%;resize:none;"></textarea>
 		<button id="btnSend" style="cursor:pointer;float:right;margin-right:15px;" onmouseover="sendMouseOver(this);" onmouseout="sendMouseOut(this);" onclick="subPersonSend();">发&nbsp&nbsp送</button>
 		<span style="float:left;font-size:9;color:#808">Ctrl+Enter发送消息</span>
	</div> 
