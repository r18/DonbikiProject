function main(){
  console.log("hoge");  
  getTweets(0,10);
}
function getTweets(startIndex,length){
  $.get("/tweets?start="+startIndex+"&length="+length,
    function(res,err){
      var tweets = JSON.parse(res);
      var list = document.getElementById('tweetList');
      for(i in tweets){
       var li = document.createElement('li');
       li.innerHTML = tweets[i].body;
       list.appendChild(li);
       console.log(i);
      }
    });
}
