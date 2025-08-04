@Application_Endpoint_Registration
Feature: CAMARA Application Endpoint Registration API, v0.1.0-rc.1 - Operations for registering application endpoints

  # Input to be provided by the implementation to the tests
  # * apiRoot: API root of the server URL
  # References to OAS spec schemas refer to schemas specified in application-endpoint-registration.yaml

  Background: Common Application Endpoint Registration setup
    Given an environment at "apiRoot"
    And the resource "/application-endpoint-registration/v0.1rc1"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"

  ######### Happy Path Scenarios #################################

  @application_endpoint_registration_01_register_app_endpoints
  Scenario: Register a new application endpoint
    Given a valid application endpoint registration request body
    When the request "registerApplicationEndpoints" is sent
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/ApplicationEndpointsId"
    And the response contains a valid application endpoint ID

  @application_endpoint_registration_02_get_all_app_endpoints
  Scenario: Retrieve all registered application endpoints
    When the request "getAllRegisteredApplicationEndpoints" is sent
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/ApplicationEndpoints"
    And the response contains a list of application endpoints

  @application_endpoint_registration_03_get_app_endpoint
  Scenario: Retrieve existing application endpoint details
    Given an application endpoint ID for an existing registered endpoint
    When the request "getApplicationEndpointsById" is sent
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/ApplicationEndpoints"
    And the response contains the correct application endpoint details

  @application_endpoint_registration_04_update_app_endpoint
  Scenario: Update an existing application endpoint
    Given an application endpoint ID for an existing registered endpoint
    And a valid application endpoint update request body
    When the request "updateApplicationEndpoint" is sent
    Then the response code is 204
    And the response header "x-correlator" has same value as the request header "x-correlator"

  @application_endpoint_registration_05_delete_app_endpoint
  Scenario: Delete an existing application endpoint
    Given an application endpoint ID for an existing registered endpoint
    When the request "deregisterApplicationEndpoint" is sent
    Then the response code is 204
    And the response header "x-correlator" has same value as the request header "x-correlator"

  ######### Error Scenarios #################################

  @application_endpoint_registration_06_invalid_registration
  Scenario: Register application endpoint with invalid data
    Given an invalid application endpoint registration request body
    When the request "registerApplicationEndpoints" is sent
    Then the response code is 400
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.code" is "INVALID_ARGUMENT"

  @application_endpoint_registration_07_endpoint_not_found
  Scenario: Retrieve non-existing application endpoint
    Given an application endpoint ID that doesn't exist
    When the request "getApplicationEndpointsById" is sent
    Then the response code is 404
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.code" is "NOT_FOUND"

  @application_endpoint_registration_08_unauthenticated
  Scenario: Register application endpoint without authentication
    Given a valid application endpoint registration request body
    And the header "Authorization" is not present
    When the request "registerApplicationEndpoints" is sent
    Then the response code is 401
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.code" is "UNAUTHENTICATED"
