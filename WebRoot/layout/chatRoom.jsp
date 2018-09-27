<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	
    <base href="<%=basePath%>">
    
    <title>Web在线聊天室</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	
	<script type="text/javascript" src="layout/js/jquery-easyui-1.6.3/jquery.min.js"></script>
	<script type="text/javascript" src="layout/js/jquery-easyui-1.6.3/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="layout/js/jquery-easyui-1.6.3/locale/easyui-lang-zh_CN.js"></script>
	
	
	<link rel="stylesheet" type="text/css" href="layout/js/jquery-easyui-1.6.3/themes/metro/easyui.css"></link>
	<link rel="stylesheet" type="text/css" href="layout/js/jquery-easyui-1.6.3/themes/icon.css"></link>
  	<link rel="stylesheet" type="text/css" href="css/style.css"></link>
  	
  	<!-- musicplayer -->
  	<script type="text/javascript" src="layout/js/music.js"></script>
  	<link rel="stylesheet" href="css/animate.css">
	<link rel="stylesheet" href="fonts/fontCss.css">
	<link rel="stylesheet" type="text/css" href="css/music.css">
	
	<script type="text/javascript">
	
		var username = "${username}";
		var lockReconnect = false; //避免ws重复连接

		// 进入聊天室，就打开socket通道
		var ws;
		var target = "ws://localhost:8080/WebSocket_chatRoom/chatSocket?username="+username;
		$(function(){		
			
			//连接socket
            createConnect(target);
            ws.onerror = function () { 
            	reconnect(target); 
			};
	
			//百度IP定位接口	
			initLocation();
	
			// 监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
			 window.onbeforeunload = function()
			  { 
			  	ws.close(); 			 	  	
			  } 
        });
          
        function initLocation(){
            var url = 'http://api.map.baidu.com/location/ip';
            var data = {
                ak: "0jShPC0gaRVmiUt5bM9EHHfeVrTbrKWA",
                coor: "bd09ll",
                callback: 'jsonpcallback'//对应值为自定义回调函数名
            };
            //组合url
            var buffer = [];
            for (var key in data) {
                buffer.push(key + '=' + encodeURIComponent(data[key]));
            }
            var fullpath = url + '?' + buffer.join('&');
            CreateScript(fullpath);
            //生成script
            function CreateScript(src){
                var el = document.createElement('script');
                el.src = src;
                el.async = true;
                el.defer = true;
                document.body.appendChild(el);
            }
        }
        function jsonpcallback(rs) {
            var city = rs['content']['address_detail']['city']; 
            city = city.substr(0,city.length-1);          
            $("#Weather").val(city);
        }
		function reconnect(url) { 
			if(lockReconnect) 
				return; 
			lockReconnect = true; 
			setTimeout(function () { 
			//没连接上会一直重连，设置延迟避免请求过多 
			createWebSocket(url); 
			lockReconnect = false; 
			}, 2000); 
		}
		function createConnect(url)
		{			
			if ('WebSocket' in window) {
                ws = new WebSocket(url);
            } else if ('MozWebSocket' in window) {
                ws = new MozWebSocket(url);
            } else {
                alert('WebSocket is not supported by this browser.');
                return;
            }
		}
	</script>
  </head>
  
  <body class="easyui-layout">
  	 
  	 <div  data-options="region:'west',split:false" style="background-color:#122C3E;width:200px;"> 
  	 	 <!-- <div id="userList" style="background-color:white;opacity:0.6;overflow-y: auto;"></div>  -->
  	 	 <jsp:include page="west.jsp"></jsp:include>   	
  	 </div>
    <div data-options="region:'center',title:'WebSocket在线聊天室'" style="padding:5px;font-family:Verdana,Genva,Arial,sans-serif;background: url(img/bg1.jpg);background-size:cover;">
	    <jsp:include page="center.jsp"></jsp:include>   	   
    </div>  
  	<div data-options="region:'south',title:'音乐随享',split:false,collapsible:false" style="background-color:#183850;height:100px;">
  	 	 <jsp:include page="musicPlayer.jsp"></jsp:include> 
  	 	<!-- <iframe scrolling="auto"  frameborder="0" src="layout/musicPlayer.jsp" style="width:100%;height:100%;"></iframe>	 -->
  	 </div>
     <div data-options="region:'east',title:'天气快报',split:false" style="background-color:#82C6F8;width:200px;">
     	 <jsp:include page="weather.jsp"></jsp:include>   	   
     </div>
  </body>
</html>
