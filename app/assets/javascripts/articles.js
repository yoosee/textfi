$(function(){ 
	if($("input#article_alt_url").value == "")
	{
		$("input#article_alt_url").val($.datepicker.formatDate('yy-mm-', new Date()));
	}
});
