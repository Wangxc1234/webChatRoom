<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	 
    <base href="<%=basePath%>">
    
    <title>登陆聊天室</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,ke	yword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<script type="text/javascript" src="layout/js/jquery-easyui-1.6.3/jquery.min.js"></script>
	<script type="text/javascript" src="layout/js/jquery-easyui-1.6.3/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="layout/js/jquery-easyui-1.6.3/locale/easyui-lang-zh_CN.js"></script>
		
	<link rel="stylesheet" type="text/css" href="layout/js/jquery-easyui-1.6.3/themes/metro/easyui.css"></link>
	<link rel="stylesheet" type="text/css" href="layout/js/jquery-easyui-1.6.3/themes/icon.css"></link>
  
	<script type="text/javascript">
	$(function() {
	
		// 初始化为easyui的form 可以拦截验证表单数据
		/* $('#user_login_loginForm').form({
		   
		});  */
        
		// 增加回车提交功能
		  $("#user_login_loginForm").bind('keyup', function(event) {
			if("13" == event.keyCode) {
				
				if($('#user_login_loginId').val() == "" || $.trim($('#user_login_loginId').val()).length == 0 || $('#user_login_loginId').val() == "群组聊天")
					return;
				$("#user_login_loginForm").submit();
			}
		});  
	});

	function validate(){
		if($('#user_login_loginId').val() == "" || $.trim($('#user_login_loginId').val()).length == 0 || $('#user_login_loginId').val() == "群组聊天"){
					return false;
		}
		else{
			return true;
		}
	}
	</script>
  </head>
  
  <body class="easyui-layout">
    <div data-options="region:'center',title:'欢迎使用Web在线聊天室'" style="padding:5px;background: url(img/bg2.jpg);background-size:cover;"></div>  
    <div id="user_login_loginDialog" class="easyui-dialog" title="登录" style="width:258px;"
        data-options="iconCls:'icon-save',closable:false,resizable:false,modal:true,
        buttons:[{
			text:'进入',
			iconCls:'icon-ok',
			handler:function(){
				var username = $('#user_login_loginId').val();
				if(username.trim()=='')
					return;
				$('#user_login_loginForm').submit();
			}
		}]">
	<form id="user_login_loginForm" action="LoginServlet" method="post" onsubmit="return validate();">
		<table>
			<tr>
				<th>用户昵称:&nbsp&nbsp</th>
				<td><input id="user_login_loginId" name="username" onkeyup="value=value.replace(/[^\u4e00-\u9fa5a-zA-Z0-9\w]/g,'')"onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" onkeydown="if(event.keyCode==13)return false;" class="easyui-validatebox" data-options="required:true,missingMessage:'用户昵称必填'"/></td>
			</tr>			
		</table>
	</form>
</div>
	<audio autoplay="autoplay" controls="controls" loop="loop"
		preload="auto" src="music/hands.mp3"></audio>
</body>
</html>
