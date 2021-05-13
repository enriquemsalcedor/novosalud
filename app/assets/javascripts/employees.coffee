# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on('turbolinks:load', ->
	jQuery ->
		$('#employee_people_attributes_territory_state_id').parent().hide()	
		territory_states = $('#employee_people_attributes_territory_state_id').html()
		$('#employee_people_attributes_territory_country_id').change (event) ->
			event.preventDefault()
			territory_country = $('#employee_people_attributes_territory_country_id :selected').text() 
			escaped_territory_country = territory_country.replace(/([ #;&,.+*~\':*!^$[\]()=>|\/@])/g, '\\$1')
			options = $(territory_states).filter("optgroup[label='#{escaped_territory_country}']").html()
			console.log(options)
			if options
				$('#employee_people_attributes_territory_state_id').html(options)
				$('#employee_people_attributes_territory_state_id').parent().show()
			else
				$('#employee_people_attributes_territory_state_id').empty()
				$('#employee_people_attributes_territory_state_id').parent().hide()
				$('#employee_people_attributes_territory_city_id').parent().hide()			
	jQuery ->
		$('#employee_people_attributes_territory_city_id').parent().hide()
		territory_cities = $('#employee_people_attributes_territory_city_id').html()
		$('#employee_people_attributes_territory_state_id').change ->
			territory_state = $('#employee_people_attributes_territory_state_id :selected').text() 
			escaped_territory_state = territory_state.replace(/([ #;&,.+*~\':*!^$[\]()=>|\/@])/g, '\\$1')
			options = $(territory_cities).filter("optgroup[label='#{escaped_territory_state}']").html()
			if options
				$('#employee_people_attributes_territory_city_id').html(options)
				$('#employee_people_attributes_territory_city_id').parent().show()
			else
				$('#employee_people_attributes_territory_city_id').empty()
				$('#employee_people_attributes_territory_city_id').parent().hide()	
)