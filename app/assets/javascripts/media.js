$(document).ready(function(){
	Dropzone.autoDiscover = false;

	$("#new_medium").dropzone({
		maxFilesize: 16,
		paramName: "medium[image]",
		addRemoveLinks: true,
			success: function(file, response) {
				$(file.previewTemplate).find('.dz-remove').attr('id', response.fileID);
				$(file.previewElement).addClass("dz-success");
				var parmalink = '';
				$.ajax({
					type: 'GET',
					url: '/media/' + response.fileID,
					success: function(data) {
						parmalink = $("img.image").attr('src')
					}
				});
				$(file.previewTemplate).append('(id:' + response.fileID + ')');
//				$(file.previewTemplate).append('<a class="dz-permalink" href="' + parmalink + '">Link</a>');
			},
			
		removefile: function(file) {
			var id = $(file.previewTempalte).find('.dz-remove').attr('id');
			$.ajax({
				type: 'DELETE',
				url: '/media/' + id,
				success: function(data) {
					console.log(data.message);
				}
			});
		}
	});
});


