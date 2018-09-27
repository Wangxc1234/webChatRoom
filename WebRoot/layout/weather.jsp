<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<form id="weatherForm">   	
  		<p style="color:green;">请输入要获取天气的城市：</p><input id="Weather" name="weather"/><input type="button" onclick="queryWeather();" value="查询"/>
</form>

<div id="weatherDiv" style="margin-top:10px;">

	<div id="currtemp"></div>
	<div id="currhum"></div>
	<div id="currwind"></div>
	<div id="lifeLead"></div>
	
	<table width="100%" top:10px; align="center">
   		
   		<tbody id="everyWeather"></tbody>
   </table>

</div>
 <script type="text/javascript">
        function queryWeather() {
        var tbody = window.document.getElementById("everyWeather");
 
            $.ajax({
                type: "POST",
                dataType: "json",//服务器返回的数据类型                
                url: "WeatherServlet" ,
                data:$('#weatherForm').serialize(),
                success: function (data) {
                
                  $("#currtemp").html("当前温度： "+data.currTempture);
                  $("#currhum").html("当前湿度： "+data.currHum);
                  $("#currwind").html("风向/风力： "+data.currWind);
                  $("#lifeLead").html("生活指数： <br>"+data.lifeLead);
                  
                 	var str = "";
                   $(data.eWeatherList).each(function(){  
						str += "<tr>" 
								+ "<td align='center'>" +this.date+ "</td>" 
								+ "<td align='center'><img src='img/weather/"+this.icon1+"'/><img src='img/weather/"+this.icon2+"'/></td>" 
								+ "<td align='center'>" + this.tempture + "</td>" 
								+ "<td align='center'>" + this.wind + "</td>" 
								+ "</tr>";                   
						  });                   
				  tbody.innerHTML = str;
 
                }, 
                error : function() {
                	var wDiv = window.document.getElementById("weatherDiv");
                    wDiv.innerHTML = "系统维护中，请稍后再试！";
                }
            });
        }
    </script>
