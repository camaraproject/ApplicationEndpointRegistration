  @application_endpoint_registration
Feature: CAMARA Application Endpoint Registration API, vwip - Operations registerApplicationEndpoints, getAllRegisteredApplicationEndpoints, getApplicationEndpointsById, updateApplicationEndpoint, deregisterApplicationEndpoint
  # Input to be provided by the implementation to the tester
  #
  # Implementation indications:
  # * apiRoot: API root of the server URL
  #
  # Testing assets:
  # * An applicationProfileId identifying an existing application profile.
  # * An applicationEndpointListId identifying existing registered application endpoints, created by the API client used for testing.
  #
  # References to OAS spec schemas refer to schemas specified in application-endpoint-registration.yaml

  Background: Common Application Endpoint Registration setup
    Given an environment at "apiRoot"
    And the resource "/application-endpoint-registration/vwip/application-endpoint-lists" as base-url
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"

  # Success scenarios

  @application_endpoint_registration_register_01_success
  Scenario: Register application endpoints
    Given the request body is set to a request body compliant with the schema at "#/components/schemas/ApplicationEndpointsInfo"
    And the request body property "$.applicationProfileId" is set to a value identifying an existing application profile
    When the request "registerApplicationEndpoints" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/ApplicationEndpointListId"

  @application_endpoint_registration_getAll_01_success
  Scenario: Retrieve all registered application endpoints
    When the request "getAllRegisteredApplicationEndpoints" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body is an array of at most 20 elements, each complying with the OAS schema at "#/components/schemas/ApplicationEndpointList"

  @application_endpoint_registration_getById_01_success
  Scenario: Retrieve registered application endpoints by identifier
    Given the path parameter "applicationEndpointListId" is set to a value identifying existing registered application endpoints
    When the request "getApplicationEndpointsById" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/ApplicationEndpointList"
    And the response property "$.applicationEndpointListId" has same value as the path parameter "applicationEndpointListId"

  @application_endpoint_registration_update_01_success
  Scenario: Update registered application endpoints
    Given the path parameter "applicationEndpointListId" is set to a value identifying existing registered application endpoints
    And the request body is set to a request body compliant with the schema at "#/components/schemas/ApplicationEndpointsInfo"
    When the request "updateApplicationEndpoint" is sent
    Then the response status code is 204
    And the response header "x-correlator" has same value as the request header "x-correlator"

  @application_endpoint_registration_update_02_changes_returned
  Scenario: Updated application endpoints are returned on retrieval
    Given the path parameter "applicationEndpointListId" is set to a value identifying existing registered application endpoints
    And the request "updateApplicationEndpoint" has been sent with a request body compliant with the schema at "#/components/schemas/ApplicationEndpointsInfo"
    When the request "getApplicationEndpointsById" is sent
    Then the response status code is 200
    And the response property "$.applicationEndpointsInfo" has the values sent in the update request body

  @application_endpoint_registration_deregister_01_success
  Scenario: Deregister application endpoints
    Given the path parameter "applicationEndpointListId" is set to a value identifying existing registered application endpoints
    When the request "deregisterApplicationEndpoint" is sent
    Then the response status code is 204
    And the response header "x-correlator" has same value as the request header "x-correlator"

  @application_endpoint_registration_deregister_02_not_found_after_deregistration
  Scenario: Deregistered application endpoints can no longer be retrieved
    Given the path parameter "applicationEndpointListId" is set to a value identifying application endpoints that have been deregistered
    When the request "getApplicationEndpointsById" is sent
    Then the response status code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  # Error code 400

  @application_endpoint_registration_400.1_no_request_body
  Scenario Outline: Missing request body
    Given the path parameter "applicationEndpointListId" is set to a value identifying existing registered application endpoints, if required by the operation
    And the request body is not included
    When the request "<operationId>" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    Examples:
      | operationId                  |
      | registerApplicationEndpoints |
      | updateApplicationEndpoint    |

  @application_endpoint_registration_400.2_empty_request_body
  Scenario Outline: Empty object as request body
    Given the path parameter "applicationEndpointListId" is set to a value identifying existing registered application endpoints, if required by the operation
    And the request body is set to "{}"
    When the request "<operationId>" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    Examples:
      | operationId                  |
      | registerApplicationEndpoints |
      | updateApplicationEndpoint    |

  @application_endpoint_registration_400.3_required_input_properties_missing
  Scenario Outline: Required input properties are missing
    Given the request body is set to a request body compliant with the schema at "#/components/schemas/ApplicationEndpointsInfo"
    And the request body property "<input_property>" is not included
    When the request "registerApplicationEndpoints" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    Examples:
      | input_property                   |
      | $.applicationEndpoints           |
      | $.applicationProviderName        |
      | $.applicationProfileId           |
      | $.applicationEndpoints[0].port   |

  @application_endpoint_registration_400.4_input_properties_schema_not_compliant
  Scenario Outline: Input property values do not comply with the schema
    Given the request body is set to a request body compliant with the schema at "#/components/schemas/ApplicationEndpointsInfo"
    And the request body property "<input_property>" does not comply with the OAS schema at "<oas_spec_schema>"
    When the request "registerApplicationEndpoints" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    Examples:
      | input_property                        | oas_spec_schema                          |
      | $.applicationProfileId                | #/components/schemas/ApplicationProfileId |
      | $.applicationEndpoints[0].port        | #/components/schemas/Port                 |
      | $.applicationEndpoints[0].domainName  | #/components/schemas/DomainName           |
      | $.applicationEndpoints[0].ipv4Address | #/components/schemas/SingleIpv4Address    |
      | $.applicationEndpoints[0].ipv6Address | #/components/schemas/SingleIpv6Address    |

  @application_endpoint_registration_400.5_no_endpoint_address
  Scenario: Application endpoint without domainName, ipv4Address or ipv6Address
    Given the request body is set to a request body compliant with the schema at "#/components/schemas/ApplicationEndpointsInfo"
    And the request body property "$.applicationEndpoints[0]" includes neither "domainName", "ipv4Address" nor "ipv6Address"
    When the request "registerApplicationEndpoints" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @application_endpoint_registration_400.6_invalid_path_parameter
  Scenario Outline: Path parameter does not comply with the schema
    Given the path parameter "applicationEndpointListId" does not comply with the OAS schema at "#/components/schemas/ApplicationEndpointListId"
    When the request "<operationId>" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    Examples:
      | operationId                   |
      | getApplicationEndpointsById   |
      | updateApplicationEndpoint     |
      | deregisterApplicationEndpoint |

  @application_endpoint_registration_400.7_invalid_x-correlator
  Scenario: Invalid x-correlator value
    Given the header "x-correlator" does not comply with the OAS schema at "#/components/schemas/XCorrelator"
    When the request "getAllRegisteredApplicationEndpoints" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  # Error code 401

  @application_endpoint_registration_401.1_no_authorization_header
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    When the request "getAllRegisteredApplicationEndpoints" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @application_endpoint_registration_401.2_expired_access_token
  Scenario: Expired access token
    Given the header "Authorization" is set to an expired access token
    When the request "getAllRegisteredApplicationEndpoints" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @application_endpoint_registration_401.3_invalid_access_token
  Scenario: Invalid access token
    Given the header "Authorization" is set to an invalid access token
    When the request "getAllRegisteredApplicationEndpoints" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  # Error code 403

  @application_endpoint_registration_403.1_missing_scope_collection
  Scenario Outline: Missing scope in the access token for collection operations
    Given the header "Authorization" is set to an access token without the required scope "<scope>"
    And the request body is set to a valid request body, if required by the operation
    When the request "<operationId>" is sent
    Then the response status code is 403
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

    Examples:
      | operationId                          | scope                                                           |
      | registerApplicationEndpoints         | application-endpoint-registration:application-endpoints:write   |
      | getAllRegisteredApplicationEndpoints | application-endpoint-registration:application-endpoints:read    |

  @application_endpoint_registration_403.2_missing_scope_item
  Scenario Outline: Missing scope in the access token for operations on registered application endpoints
    Given the header "Authorization" is set to an access token without the required scope "<scope>"
    And the path parameter "applicationEndpointListId" is set to a value identifying existing registered application endpoints
    And the request body is set to a valid request body, if required by the operation
    When the request "<operationId>" is sent
    Then the response status code is 403
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

    Examples:
      | operationId                   | scope                                                            |
      | getApplicationEndpointsById   | application-endpoint-registration:application-endpoints:read     |
      | updateApplicationEndpoint     | application-endpoint-registration:application-endpoints:update   |
      | deregisterApplicationEndpoint | application-endpoint-registration:application-endpoints:delete   |

  # Error code 404

  @application_endpoint_registration_404.1_application_endpoint_list_not_found
  Scenario Outline: The applicationEndpointListId does not identify registered application endpoints
    Given the path parameter "applicationEndpointListId" is compliant with the schema but does not identify registered application endpoints
    And the request body is set to a valid request body, if required by the operation
    When the request "<operationId>" is sent
    Then the response status code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

    Examples:
      | operationId                   |
      | getApplicationEndpointsById   |
      | updateApplicationEndpoint     |
      | deregisterApplicationEndpoint |

  @application_endpoint_registration_404.2_application_profile_not_found
  Scenario: The applicationProfileId does not identify an existing application profile
    Given the request body is set to a request body compliant with the schema at "#/components/schemas/ApplicationEndpointsInfo"
    And the request body property "$.applicationProfileId" is compliant with the schema but does not identify an existing application profile
    When the request "registerApplicationEndpoints" is sent
    Then the response status code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text
