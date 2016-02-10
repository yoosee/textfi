$(document).ready(function(){
	Dropzone.autoDiscover = false;

	$("#new_medium").dropzone({
		maxFilesize: 16,
		paramName: "medium[image]",
		addRemoveLinks: true,
			success: function(file, response) {
				$(file.previewTemplate).find('.dz-remove').attr('id', response.fileID);
				$(file.previewElement).addClass("dz-success");
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


