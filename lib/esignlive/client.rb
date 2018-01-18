require 'esignlive/api/calls'

module ESignLive
  class Client
    include ESignLive::API::Calls

    attr_reader :headers, :environment, :url_version, :url

    VALID_ENVIRONMENTS = %w(sandbox production)

    VALID_URL_VERSIONS = %w( us_11 us_10 us_gov ca aus eu )
    API_URLS = {
                  us_11:  {
                            sandbox: 'https://sandbox.esignlive.com/api',
                            production: 'https://apps.esignlive.com/api'
                          },
                  us_10:  {
                            sandbox: 'https://sandbox.e-signlive.com/api',
                            production: 'https://apps.e-signlive.com/api'
                          },
                  us_gov: {
                            sandbox: 'https://signer-sandbox-gov.esignlive.com/api',
                            production: 'https://signer-gov.esignlive.com/api'
                          },
                  ca:     {
                            sandbox: 'https://sandbox.e-signlive.ca/api',
                            production: 'https://apps.e-signlive.ca/api'
                          },
                  aus:    {
                            sandbox: '',
                            production: 'https://apps.esignlive.com.au/api'
                          },
                  eu:     {
                            sandbox: '',
                            production: 'https://apps.esignlive.eu/api'
                          }
                }

    def initialize(api_key:, environment: "sandbox", url_version: 'us_11')
      check_url_version(url_version)
      check_environment(environment)

      @headers      = create_headers(api_key)
      @url          = get_url(url_version, environment)
      @environment  = environment

    end

    def get_url url_version, env
      @url = API_URLS[url_version.to_sym][env.to_sym]
    end

    private

    def create_headers(api_key)
      {
        'Content-Type' => 'application/json',
        'Authorization' => "Basic #{api_key}"
      }
    end

    def check_url_version(url_version)
      unless VALID_URL_VERSIONS.include?(url_version)
        urls_link = 'https://docs.esignlive.com/content/c_integrator_s_guide/rest_api/rest_api.htm'
        raise UrlVersionError.new("url version must be set to one of the following: #{VALID_URL_VERSIONS.join(',')}. Check #{urls_link}")
      end
    end

    def check_environment(env)
      unless VALID_ENVIRONMENTS.include?(env)
        raise EnvironmentError.new("environment must be set to 'sandbox' or 'production'")
      end
    end

    class EnvironmentError < StandardError ; end
    class UrlVersionError < StandardError ; end
  end
end
