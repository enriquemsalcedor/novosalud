# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on('turbolinks:load', ->
	jQuery ->
		$('#business_company_territory_state_id').parent().hide()	
		territory_states = $('#business_company_territory_state_id').html()
		$('#business_company_territory_country_id').change (event) ->
			event.preventDefault()
			territory_country = $('#business_company_territory_country_id :selected').text() 
			escaped_territory_country = territory_country.replace(/([ #;&,.+*~\':*!^$[\]()=>|\/@])/g, '\\$1')
			options = $(territory_states).filter("optgroup[label='#{escaped_territory_country}']").html()
			console.log(options)
			if options
				$('#business_company_territory_state_id').html(options)
				$('#business_company_territory_state_id').parent().show()
			else
				$('#business_company_territory_state_id').empty()
				$('#business_company_territory_state_id').parent().hide()
				$('#business_company_territory_city_id').parent().hide()			
	jQuery ->
		$('#business_company_territory_city_id').parent().hide()
		territory_cities = $('#business_company_territory_city_id').html()
		$('#business_company_territory_state_id').change ->
			territory_state = $('#business_company_territory_state_id :selected').text() 
			escaped_territory_state = territory_state.replace(/([ #;&,.+*~\':*!^$[\]()=>|\/@])/g, '\\$1')
			options = $(territory_cities).filter("optgroup[label='#{escaped_territory_state}']").html()
			if options
				$('#business_company_territory_city_id').html(options)
				$('#business_company_territory_city_id').parent().show()
			else
				$('#business_company_territory_city_id').empty()
				$('#business_company_territory_city_id').parent().hide()	
)