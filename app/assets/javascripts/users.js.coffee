# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

@click_hidden = (box) ->
	hidden = document.getElementById("hidden_" + box.value);
	hidden.checked = box.checked;