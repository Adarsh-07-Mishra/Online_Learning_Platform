# frozen_string_literal: true

require 'test_helper'

class SubjectsControllerTest < ActionDispatch::IntegrationTest
  test 'should get show' do
    get subjects_show_url
    assert_response :success
  end
end
