# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
	$("#container").highcharts({
		chart: {
			height: 300
		},
		title: {
			text: "Direct Average Price"
		},
		xAxis: {
			allowDecimals: false
		},
		yAxis: {
			title: {
				text: "Price $"
			},
			min: 0
		},
		series: [{
			name: "Daily Average Direct Price",
			data: $("#container").data("direct")
			}]
	})

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


	if $(".flights .panel-heading").size() > 0
		$(".flights .panel-heading").first().click()
		if $(".flights .panel-body").first().find(".panel-heading").size() > 0
			$(".flights .panel-body").first().find(".panel-heading").first().click()
