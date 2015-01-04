var view = function (){
	var source = "<span>lol</span>";
	
	return {
		render: function (viewmodel) {
			var template = Handlebars.compile(source);
			$('body').append($.parseHTML(template(viewmodel)));
		},
	};
} 

var controller = function () {
	return {};
};

$(document).ready(function () {

});