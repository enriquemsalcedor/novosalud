# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on('turbolinks:load', ->
	jQuery ->
		$('#customer_people_attributes_territory_state_id').parent().hide()	
		territory_states = $('#customer_people_attributes_territory_state_id').html()
		$('#customer_people_attributes_territory_country_id').change (event) ->
			event.preventDefault()
			territory_country = $('#customer_people_attributes_territory_country_id :selected').text() 
			escaped_territory_country = territory_country.replace(/([ #;&,.+*~\':*!^$[\]()=>|\/@])/g, '\\$1')
			options = $(territory_states).filter("optgroup[label='#{escaped_territory_country}']").html()
			console.log(options)
			if options
				$('#customer_people_attributes_territory_state_id').html(options)
				$('#customer_people_attributes_territory_state_id').parent().show()
			else
				$('#customer_people_attributes_territory_state_id').empty()
				$('#customer_people_attributes_territory_state_id').parent().hide()
				$('#customer_people_attributes_territory_city_id').parent().hide()			
	jQuery ->
		$('#customer_people_attributes_territory_city_id').parent().hide()
		territory_cities = $('#customer_people_attributes_territory_city_id').html()
		$('#customer_people_attributes_territory_state_id').change ->
			territory_state = $('#customer_people_attributes_territory_state_id :selected').text() 
			escaped_territory_state = territory_state.replace(/([ #;&,.+*~\':*!^$[\]()=>|\/@])/g, '\\$1')
			options = $(territory_cities).filter("optgroup[label='#{escaped_territory_state}']").html()
			if options
				$('#customer_people_attributes_territory_city_id').html(options)
				$('#customer_people_attributes_territory_city_id').parent().show()
			else
				$('#customer_people_attributes_territory_city_id').empty()
				$('#customer_people_attributes_territory_city_id').parent().hide()	
)