<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<div class="music-bg" style="height: 100%;filter: blur(100px);transition:all 0.3s" id="music-bg">
		<div class="music-mask"></div>
</div>
<script>

	window.onload = function(){
	
        var source = [];
               
        //请求QQ音乐
		let url = 'https://c.y.qq.com/v8/fcg-bin/fcg_v8_toplist_cp.fcg?g_tk=5381&uin=0&format=json&inCharset=utf-8&outCharset=utf-8&notice=0&platform=h5&needNewCode=1&tpl=3&page=detail&type=top&topid=27&_=1519963122923guid=126548448';

        $.ajax({
          url:url,
          type:"get",
          dataType:'jsonp',
          jsonp: "jsonpCallback",
          scriptCharset: 'GBK',//解决中文乱码
          async: false,
          success: function(data){
          //qq新歌榜音乐数据
          
          $(data.songlist).each(function(){
          		var obj = null;
					obj = {
							"name":this.data.songname,
							"singer":this.data.singer[0].name,
							"url":'http://ws.stream.qqmusic.qq.com/C100'+this.data.songmid+'.m4a?fromtag=0&guid=126548448',
							"img_url":'http://y.gtimg.cn/music/photo_new/T002R90x90M000'+this.data.albummid+'.jpg?max_age=2592000'											
							}
					source.push(obj);
          		});	
          				          	 
				MC.music({
				
					hasAjax:false,
					left:'50%',
					bottom:'-4.5%',
					source:source,
					musicChanged:function(ret){
						
						var data = ret.data;
						var index = ret.index;
						var imageUrl = data[index].img_url;
						
						var music_bg = document.getElementById('music-bg');
						music_bg.style.background = 'url('+imageUrl+')no-repeat';
						music_bg.style.backgroundSize = 'cover';
						music_bg.style.backgroundPosition = 'center 30%';
					},
		
				});
				 	         
          },
          error:function (e) {
                console.log('qq音乐获取失败');
              }
        });
        //图片获取示例
        //'http://y.gtimg.cn/music/photo_new/T002R90x90M000'+albummid+'.jpg?max_age=2592000'
    	//歌曲获取示例
        //'http://ws.stream.qqmusic.qq.com/C100'+songMessage.songmid+'.m4a?fromtag=0&guid=126548448'
    
	}
</script>