require File.expand_path('../helper', __FILE__)

class CodeshipTest < Service::TestCase
  include Service::HttpTestMethods

  def test_push_event
    project_uuid = '2fe6bdb0-a6db-0131-f25b-0088653824b4'

    data = { 'project_uuid' => project_uuid }

    svc = service(:push, data, payload)

    @stubs.post "/github/#{project_uuid}" do |env|
      payload_body = JSON.parse(env[:body][:payload])
      assert_equal "https://lighthouse.codeship.io/github/#{project_uuid}", env[:url].to_s
      assert_match 'application/json', env[:request_headers]['Content-Type']
      assert_equal 'push', env[:request_headers]['X-GitHub-Event']
      assert_equal payload, payload_body
    end

    svc.receive_event
  end

  private

  def service_class
    Service::Codeship
  end
end
