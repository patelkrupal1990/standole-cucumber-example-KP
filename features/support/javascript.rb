def trigger_change_event_for_input(field)
  wait_until_all_ajax_requests_complete
  id = page.find(:css, "label:contains('#{field}')")[:for]
  page.execute_script("$('##{id}').trigger('change')")
  wait_until_all_ajax_requests_complete
end

def trigger_change_event_for_field_id(id)
  wait_until_all_ajax_requests_complete
  page.execute_script("$('##{id}').change().blur()")
  wait_until_all_ajax_requests_complete
end

def wait_until_all_ajax_requests_complete
  sleep(1) until page.evaluate_script('$.active') == 0
end 
