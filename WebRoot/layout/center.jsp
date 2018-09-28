<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

	<style type="text/css">		
		.left{
			margin-left:40px;
		}				
	</style>

	<script type="text/javascript">
		
		$(function(){		
			
			//发消息
			ws.onmessage = function(event){
				
				var obj = JSON.parse(event.data);
				
				if(undefined!= obj.welcome && obj.type != 2)
				{
					$("#content").append("<h4 style='color:red;text-align:center;'>"+obj.welcome+"</h4><br>")
				}
				
				if(undefined!= obj.usernames)
				{
					//$("#userList").html("");
					//$("#userList").append("<input type='radio' checked='true' name='UserList' value='GROUP' /><span style='font-family:Cursive;text-align:center;color:green;font-size:22;'>群组聊天</span><br>");
					
					//$("#list").html("");	
									
					//$("#list").append("<li style='cursor:pointer;font-size:18;' onmouseover='liMouseOver(this);' onmouseout='liMouseOut(this);'>群组聊天</li>");
					
					
					//var objJson = [{"text":"群组聊天","iconCls":"icon-man","state":"open","checked":true}];
					var objJson = [];
					//循环用户
					$(obj.usernames).each(function(){
					
						//$("#userList").append("<input type='radio' name='UserList' value='"+this+"' /><span style='font-family:Cursive;text-align:center;color:green;font-size:20;'>"+this+"</span><br>");
						//$("#list").append("<li style='cursor:pointer;font-size:18;' onmouseover='liMouseOver(this);' onmouseout='liMouseOut(this);'>"+this+"</li>");
						var obj = null;
						obj = {
							"text":this,
							"iconCls":"icon-man",
							"state":"open"						
						}
						objJson.push(obj);
												
					});
				}
				
				$('#list').tree({
					data: objJson,
					onClick: function(node){
						if(node.text==username)
						{
							return;
						}
						var content ='<iframe scrolling="auto" id="'+node.text+'" frameborder="0" src="layout/common.jsp" style="width:100%;height:100%;"></iframe>';

						addTab({
							title: node.text,	
							content:content,											
							closable: true,
							selected:true
						});
					}
				});	
								
				if(undefined == obj.type)
				{
					return;
				}
			
				var date = getNowFormatDate();
				if(obj.type==1){
					if(undefined != obj.contentUsername) {
						if(obj.contentUsername==username)
						{
							
							var scale = 1-((username.length+date.length)*12)/($("#content").width());
							var percent = toPercent(scale);
							var percent1 = toPercent(scale+0.02);
							
							if(undefined != obj.contentMsg){
							}
						}
						else{
							$("#content").append("<p style='margin-left:12px;'>"+obj.contentUsername+"&nbsp&nbsp"+date+"</p>");
							if(undefined != obj.contentMsg){
							}
						}
					}
				}
			 	//接收信息				
				//有人私聊我
				else if(obj.type == 2)
				{
				
					 if(undefined != obj.fromPerson && undefined != obj.toPerson && obj.toPerson == username)
					{
						var t = $("#layout_center_centerTabs");
						if(t.tabs("exists", obj.fromPerson)) {
							// 如果有tiele选中
							t.tabs("select", obj.fromPerson);
						}else {
							// 如果没有新增
							var content ='<iframe scrolling="auto" id="'+obj.fromPerson+'" frameborder="0" src="layout/common.jsp" style="width:100%;height:100%;"></iframe>';
							var opts = {						
								title: obj.fromPerson,	
								content:content,											
								closable: true,
								selected:true
							}
							t.tabs("add", opts);
							
							//在没有标签页的情况下，接收不到消息,向后台发送提醒
						
							obj = {
								to: obj.fromPerson,
								msg: '自动回复：您好，我刚刚有事不在，未接收到消息。请再发一次！',
								type: 2// 私聊
								}		
							// 返回后台json格式字符串
							var json = JSON.stringify(obj);
							ws.send(json);										
						}								
					}
					
					var tab = $('#layout_center_centerTabs').tabs('getSelected');
					var title = tab.panel('options').title;		//获取本页面的title
					var index = tab.panel('options').index;		//获取本页面的index
					var strTitle= ""+title.toString();
					
					var newId = strTitle+"_"+index;
				
					
						//自己发信息	
					if(obj.fromPerson == username) {					
						
						if(obj.toPerson==strTitle)		
						{
							if(undefined!= obj.welcome)
							{									
								alert(obj.welcome);	
								$('#layout_center_centerTabs').tabs('close',index);						
								return;
							}
							var iframe = document.getElementById(obj.toPerson).contentWindow;
							var div =iframe.document.getElementById(newId);
							
							var scale = 1-((obj.fromPerson.length+date.length)*12)/(div.offsetWidth);
							var percent = toPercent(scale);
							
							var eleP = document.createElement("p");
							eleP.setAttribute('style', 'margin-left:'+percent);	
							eleP.innerHTML = obj.fromPerson+"&nbsp&nbsp"+date;							
							div.appendChild(eleP);
							
							
							//$("#"+newId).append("<p style='margin-left:"+percent+";'>"+obj.fromPerson+"&nbsp&nbsp"+date+"</p>");
							if(undefined != obj.contentMsg){
							
								var eleDiv = document.createElement("div");
								eleDiv.setAttribute('class', 'right');	
								eleDiv.innerHTML = "<p>"+obj.contentMsg+"</p>";						
								div.appendChild(eleDiv);
							
							
								//$("#"+newId).append("<div class='right'  style='left:"+percent1+";max-width:300px;top:0px;height:40px;'><p>"+obj.contentMsg+"</p></div>");
							}
						}				
					}				
					
					//判断来信是否是给自己的			
					
					if(obj.toPerson == username)
					{						
						if(undefined != obj.fromPerson)		
						{					
							var iframe = document.getElementById(obj.fromPerson).contentWindow;
							var div =iframe.document.getElementById(newId);
								
							//console.info($("#"+newId,document.getElementById(obj.fromPerson).document));
							
							var eleP = document.createElement("p");
							eleP.setAttribute('style', 'margin-left:12px');	
							eleP.innerHTML = obj.fromPerson+"&nbsp&nbsp"+date;							
							div.appendChild(eleP);
							
							//$("#"+newId).append("<p style='margin-left:12px;'>"+obj.fromPerson+"&nbsp&nbsp"+date+"</p>");
								if(undefined != obj.contentMsg){
									var eleDiv = document.createElement("div");
									eleDiv.setAttribute('class', 'left');	
									eleDiv.innerHTML = "<p>"+obj.contentMsg+"</p>";							
									div.appendChild(eleDiv);
								
									//$("#"+newId).append("<div class='left'  style='max-width:300px;height:40px;'><p>"+obj.contentMsg+"</p></div><br>");
							}	
						}					
					}		
				}  			
			};
		
			// 增加Ctrl+回车提交功能
			$('#msg').keypress(function (event){
			     if (event.ctrlKey && event.keyCode == 13||event.keyCode == 10)  {
			        subSend();
			    }
			});
	
		});
	
			// 群发
		function subSend() {
			var msg = $("#msg").val();
			if(msg==""||msg.trim()==""){
				$("#msg").val("");
				return;
			}
			
			$("#msg").val("");			
			
			var t = $("#layout_center_centerTabs");
			var tab =t.tabs('getSelected');			
			
			var title = tab.panel('options').title;			
											
			// 用于返回后台的json对象
			var obj = null;
			if(title==username ||title!="群组聊天")
			{
				return;
			}			
			obj = {
				msg: msg,
				type: 1// 广播
			}					
			// 返回后台json格式字符串
			var json = JSON.stringify(obj);
			ws.send(json);	
			
		}
		
		//获取格式化时间
		function getNowFormatDate() {
		    var date = new Date();
		    var seperator1 = "-";
		    var seperator2 = ":";
		    var month = date.getMonth() + 1;
		    var strDate = date.getDate();
		    if (month >= 1 && month <= 9) {
		        month = "0" + month;
		    }
		    if (strDate >= 0 && strDate <= 9) {
		        strDate = "0" + strDate;
		    }
		    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
		            + " " + date.getHours() + seperator2 + date.getMinutes()
		            + seperator2 + date.getSeconds();
		    return currentdate;
		}

		
		function sendMouseOver(obj){
			obj.style.backgroundColor='green';
			obj.style.color='white';
		}
		function sendMouseOut(obj){
			obj.style.backgroundColor='white';
			obj.style.color='';
		}
		
		// 转换百分数保留两位小数
		function toPercent(point){
		    var str=Number(point*100).toFixed(2);
		    str+="%";
		    return str;
		}
		
		function addTab(opts) {
			var t = $("#layout_center_centerTabs");
			if(t.tabs("exists", opts.title)) {
				// 如果有tiele选中
				t.tabs("select", opts.title);
			}else {
				// 如果没有新增
				t.tabs("add", opts);
			}
		} 
	</script>
	 <div id="layout_center_centerTabs" class="easyui-tabs" data-options="fit:true" style=" width:100%;height:100%;background-color:white;opacity:0.7;">
		 <div id="container" title="群组聊天" data-options="selected:true">		      	
	    	<div id="content" style="overflow-y: auto;height:82%;"></div>
			<div style=" border-radius: 4px; box-shadow:inset 0 10px 0 0 #ccc;">
		 		<textarea id="msg" style="border-style:none;width:100%;resize:none;"></textarea>
		 		<button id="btnSend" style="cursor:pointer;float:right;margin-right:15px;" onmouseover="sendMouseOver(this);" onmouseout="sendMouseOut(this);" onclick="subSend();">发&nbsp&nbsp送</button>
		 		<span style="float:left;font-size:9;color:#808">Ctrl+Enter发送消息</span>
			</div> 
		  </div>
	</div>	