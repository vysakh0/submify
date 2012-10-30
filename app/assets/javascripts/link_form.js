
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js" type="text/javascript"></script>
<script type='text/javascript'>


 $("#submit_button").hide();

$('#complete_url').bind('input propertychange', function() {

      if(this.value.length==0){
        $("#submit_button").hide();
      }
});


$('#complete_url').keyup(function(evt){
	if (evt.keyCode == 32) {
	 
	var hi = $('#complete_url').val();
	
	if(hi != null){
		
	
	 $("#submit_button").show();
	
	}
	
	}
});

$('#complete_url').bind('paste', function(e) {
	
	setTimeout(function() {
	var h = $('#complete_url').val();
	if(h != null){
		
		 $("#submit_button").show();
	}
	}, 500);
	
});


</script>
