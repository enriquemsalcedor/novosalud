# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on('turbolinks:load', ->
	jQuery ->
		$('#provider_provider_territory_state_id').parent().parent().hide()	
		territory_states = $('#provider_provider_territory_state_id').html()
		$('#provider_provider_territory_country_id').change (event) ->
			event.preventDefault()
			territory_country = $('#provider_provider_territory_country_id :selected').text() 
			escaped_territory_country = territory_country.replace(/([ #;&,.+*~\':*!^$[\]()=>|\/@])/g, '\\$1')
			options = $(territory_states).filter("optgroup[label='#{escaped_territory_country}']").html()
			console.log(options) 
			if options
				$('#provider_provider_territory_state_id').html(options)
				$('#provider_provider_territory_state_id').parent().parent().show()
			else
				$('#provider_provider_territory_state_id').empty()
				$('#provider_provider_territory_state_id').parent().parent().hide()
				$('#provider_provider_territory_city_id').parent().parent().hide()			
	jQuery ->
		$('#provider_provider_territory_city_id').parent().parent().hide()
		territory_cities = $('#provider_provider_territory_city_id').html()
		$('#provider_provider_territory_state_id').change (event) ->
			event.preventDefault()
			territory_state = $('#provider_provider_territory_state_id :selected').text() 
			escaped_territory_state = territory_state.replace(/([ #;&,.+*~\':*!^$[\]()=>|\/@])/g, '\\$1')
			options = $(territory_cities).filter("optgroup[label='#{escaped_territory_state}']").html()
			if options
				$('#provider_provider_territory_city_id').html(options)
				$('#provider_provider_territory_city_id').parent().parent().show()
			else
				$('#provider_provider_territory_city_id').empty()
				$('#provider_provider_territory_city_id').parent().parent().hide()	
) 

