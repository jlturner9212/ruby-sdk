# frozen_string_literal: true

# Copyright 2018 IBM All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Analyze various features of text content at scale. Provide text, raw HTML, or a public
# URL and IBM Watson Natural Language Understanding will give you results for the features
# you request. The service cleans HTML content before analysis by default, so the results
# can ignore most advertisements and other unwanted content.
#
# You can create [custom
# models](/docs/services/natural-language-understanding/customizing.html) with Watson
# Knowledge Studio to detect custom entities and relations in Natural Language
# Understanding.

require "concurrent"
require "erb"
require "json"
require_relative "./detailed_response"

require_relative "./watson_service"

# Module for the Watson APIs
module IBMWatson
  ##
  # The Natural Language Understanding V1 service.
  class NaturalLanguageUnderstandingV1 < WatsonService
    include Concurrent::Async
    ##
    # @!method initialize(args)
    # Construct a new client for the Natural Language Understanding service.
    #
    # @param args [Hash] The args to initialize with
    # @option args version [String] The API version date to use with the service, in
    #   "YYYY-MM-DD" format. Whenever the API is changed in a backwards
    #   incompatible way, a new minor version of the API is released.
    #   The service uses the API version for the date you specify, or
    #   the most recent version before that date. Note that you should
    #   not programmatically specify the current date at runtime, in
    #   case the API has been updated since your application's release.
    #   Instead, specify a version date that is compatible with your
    #   application, and don't change it until your application is
    #   ready for a later version.
    # @option args url [String] The base url to use when contacting the service (e.g.
    #   "https://gateway.watsonplatform.net/natural-language-understanding/api").
    #   The base url may differ between Bluemix regions.
    # @option args username [String] The username used to authenticate with the service.
    #   Username and password credentials are only required to run your
    #   application locally or outside of Bluemix. When running on
    #   Bluemix, the credentials will be automatically loaded from the
    #   `VCAP_SERVICES` environment variable.
    # @option args password [String] The password used to authenticate with the service.
    #   Username and password credentials are only required to run your
    #   application locally or outside of Bluemix. When running on
    #   Bluemix, the credentials will be automatically loaded from the
    #   `VCAP_SERVICES` environment variable.
    # @option args iam_apikey [String] An API key that can be used to request IAM tokens. If
    #   this API key is provided, the SDK will manage the token and handle the
    #   refreshing.
    # @option args iam_access_token [String] An IAM access token is fully managed by the application.
    #   Responsibility falls on the application to refresh the token, either before
    #   it expires or reactively upon receiving a 401 from the service as any requests
    #   made with an expired token will fail.
    # @option args iam_url [String] An optional URL for the IAM service API. Defaults to
    #   'https://iam.ng.bluemix.net/identity/token'.
    def initialize(args = {})
      @__async_initialized__ = false
      defaults = {}
      defaults[:version] = nil
      defaults[:url] = "https://gateway.watsonplatform.net/natural-language-understanding/api"
      defaults[:username] = nil
      defaults[:password] = nil
      defaults[:iam_apikey] = nil
      defaults[:iam_access_token] = nil
      defaults[:iam_url] = nil
      args = defaults.merge(args)
      args[:vcap_services_name] = "natural-language-understanding"
      super
      @version = args[:version]
    end

    #########################
    # Analyze
    #########################

    ##
    # @!method analyze(features:, text: nil, html: nil, url: nil, clean: nil, xpath: nil, fallback_to_raw: nil, return_analyzed_text: nil, language: nil, limit_text_characters: nil)
    # Analyze text, HTML, or a public webpage.
    # Analyzes text, HTML, or a public webpage with one or more text analysis features,
    #   including categories, concepts, emotion, entities, keywords, metadata, relations,
    #   semantic roles, and sentiment.
    # @param features [Features] Specific features to analyze the document for.
    # @param text [String] The plain text to analyze. One of the `text`, `html`, or `url` parameters is
    #   required.
    # @param html [String] The HTML file to analyze. One of the `text`, `html`, or `url` parameters is
    #   required.
    # @param url [String] The web page to analyze. One of the `text`, `html`, or `url` parameters is
    #   required.
    # @param clean [Boolean] Remove website elements, such as links, ads, etc.
    # @param xpath [String] An [XPath query](https://www.w3.org/TR/xpath/) to perform on `html` or `url`
    #   input. Results of the query will be appended to the cleaned webpage text before it
    #   is analyzed. To analyze only the results of the XPath query, set the `clean`
    #   parameter to `false`.
    # @param fallback_to_raw [Boolean] Whether to use raw HTML content if text cleaning fails.
    # @param return_analyzed_text [Boolean] Whether or not to return the analyzed text.
    # @param language [String] ISO 639-1 code that specifies the language of your text. This overrides automatic
    #   language detection. Language support differs depending on the features you include
    #   in your analysis. See [Language
    #   support](https://www.bluemix.net/docs/services/natural-language-understanding/language-support.html)
    #   for more information.
    # @param limit_text_characters [Fixnum] Sets the maximum number of characters that are processed by the service.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def analyze(features:, text: nil, html: nil, url: nil, clean: nil, xpath: nil, fallback_to_raw: nil, return_analyzed_text: nil, language: nil, limit_text_characters: nil)
      raise ArgumentError("features must be provided") if features.nil?

      headers = {
      }
      params = {
        "version" => @version
      }
      data = {
        "features" => features,
        "text" => text,
        "html" => html,
        "url" => url,
        "clean" => clean,
        "xpath" => xpath,
        "fallback_to_raw" => fallback_to_raw,
        "return_analyzed_text" => return_analyzed_text,
        "language" => language,
        "limit_text_characters" => limit_text_characters
      }
      method_url = "/v1/analyze"
      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        json: data,
        accept_json: true
      )
      response
    end
    #########################
    # Manage models
    #########################

    ##
    # @!method list_models
    # List models.
    # Lists available models for Relations and Entities features, including Watson
    #   Knowledge Studio custom models that you have created and linked to your Natural
    #   Language Understanding service.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def list_models
      headers = {
      }
      params = {
        "version" => @version
      }
      method_url = "/v1/models"
      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end

    ##
    # @!method delete_model(model_id:)
    # Delete model.
    # Deletes a custom model.
    # @param model_id [String] model_id of the model to delete.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def delete_model(model_id:)
      raise ArgumentError("model_id must be provided") if model_id.nil?

      headers = {
      }
      params = {
        "version" => @version
      }
      method_url = "/v1/models/%s" % [ERB::Util.url_encode(model_id)]
      response = request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end
  end
end
