# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
	# $(".datepicker").datepicker()

	$(".searches .list-group-item").hover (->
		$(".search .list-group-item").removeClass("active")
		$(this).addClass("info")
		return
  ), ->
		$(".searches .list-group-item").removeClass("active")
		return

	$(".flights .panel").mouseenter (->
		$(this).addClass("panel-info"))
	$(".flights .panel").mouseleave (->
		$(this).removeClass("panel-info"))

	$(".flights .flight").mouseenter (->
		$(this).addClass("active"))
	$(".flights .flight").mouseleave (->
		$(this).removeClass("active"))

	$(".flights .panel-heading").click(->
		$(this).siblings(".panel-body").toggle("show"))

