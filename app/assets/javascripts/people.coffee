# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on('turbolinks:load', ->
	jQuery ->
		$('#people_territory_state_id').parent().hide()	
		territory_states = $('#people_territory_state_id').html()
		$('#people_territory_country_id').change ->
			territory_country = $('#people_territory_country_id :selected').text() 
			escaped_territory_country = territory_country.replace(/([ #;&,.+*~\':*!^$[\]()=>|\/@])/g, '\\$1')
			options = $(territory_states).filter("optgroup[label='#{escaped_territory_country}']").html()
			console.log(options)
			if options
				$('#people_territory_state_id').html(options)
				$('#people_territory_state_id').parent().show()
			else
				$('#people_territory_state_id').empty()
				$('#people_territory_state_id').parent().hide()
				$('#people_territory_city_id').parent().hide()			
	jQuery ->
		$('#people_territory_city_id').parent().hide()
		territory_cities = $('#people_territory_city_id').html()
		$('#people_territory_state_id').change ->
			territory_state = $('#people_territory_state_id :selected').text() 
			escaped_territory_state = territory_state.replace(/([ #;&,.+*~\':*!^$[\]()=>|\/@])/g, '\\$1')
			options = $(territory_cities).filter("optgroup[label='#{escaped_territory_state}']").html()
			if options
				$('#people_territory_city_id').html(options)
				$('#people_territory_city_id').parent().show()
			else
				$('#people_territory_city_id').empty()
				$('#people_territory_city_id').parent().hide()	
) 