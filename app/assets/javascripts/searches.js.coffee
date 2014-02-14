# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
	$("#datepicker").datepicker()

	$(".searches .list-group-item").hover (->
		$(".search .list-group-item").removeClass("active")
		$(this).addClass("active")
		return
  ), ->
		$(".searches .list-group-item").removeClass("active")
		return
