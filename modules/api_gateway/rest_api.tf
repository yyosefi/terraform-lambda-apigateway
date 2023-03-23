resource "aws_api_gateway_rest_api" "rest_api"{
  name = var.rest_api_name

  endpoint_configuration {
    types = ["REGIONAL"]
  }  
}

resource "aws_api_gateway_resource" "rest_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part = "hola"
}

resource "aws_api_gateway_method" "rest_api_options_method" {
  rest_api_id      = aws_api_gateway_rest_api.rest_api.id
  resource_id      = aws_api_gateway_resource.rest_api_resource.id
  http_method      = "OPTIONS"
  authorization    = "NONE"
}

resource "aws_api_gateway_method" "rest_api_post_method" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.rest_api_resource.id
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "rest_api_options_method_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.rest_api_resource.id
  http_method             = aws_api_gateway_method.rest_api_options_method.http_method
  type                    = "MOCK"
  uri                     = var.lambda_function_arn
  passthrough_behavior    = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration" "rest_api_post_method_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.rest_api_resource.id
  http_method             = aws_api_gateway_method.rest_api_post_method.http_method
  type                    = "AWS"
  uri                     = var.lambda_function_arn
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  content_handling        = "CONVERT_TO_TEXT"

  request_templates = {
    "application/json" = "##  See http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-mapping-template-reference.html\r\n##  This template will pass through all parameters including path, querystring, header, stage variables, and context through to the integration endpoint via the body/payload\r\n#set($allParams = $input.params())\r\n{\r\n\"body-json\" : $input.json('$'),\r\n\"params\" : {\r\n#foreach($type in $allParams.keySet())\r\n    #set($params = $allParams.get($type))\r\n\"$type\" : {\r\n    #foreach($paramName in $params.keySet())\r\n    \"$paramName\" : \"$util.escapeJavaScript($params.get($paramName))\"\r\n        #if($foreach.hasNext),#end\r\n    #end\r\n}\r\n    #if($foreach.hasNext),#end\r\n#end\r\n},\r\n\"stage-variables\" : {\r\n#foreach($key in $stageVariables.keySet())\r\n\"$key\" : \"$util.escapeJavaScript($stageVariables.get($key))\"\r\n    #if($foreach.hasNext),#end\r\n#end\r\n},\r\n\"context\" : {\r\n    \"account-id\" : \"$context.identity.accountId\",\r\n    \"api-id\" : \"$context.apiId\",\r\n    \"api-key\" : \"$context.identity.apiKey\",\r\n    \"authorizer-principal-id\" : \"$context.authorizer.principalId\",\r\n    \"caller\" : \"$context.identity.caller\",\r\n    \"cognito-authentication-provider\" : \"$context.identity.cognitoAuthenticationProvider\",\r\n    \"cognito-authentication-type\" : \"$context.identity.cognitoAuthenticationType\",\r\n    \"cognito-identity-id\" : \"$context.identity.cognitoIdentityId\",\r\n    \"cognito-identity-pool-id\" : \"$context.identity.cognitoIdentityPoolId\",\r\n    \"http-method\" : \"$context.httpMethod\",\r\n    \"stage\" : \"$context.stage\",\r\n    \"source-ip\" : \"$context.identity.sourceIp\",\r\n    \"user\" : \"$context.identity.user\",\r\n    \"user-agent\" : \"$context.identity.userAgent\",\r\n    \"user-arn\" : \"$context.identity.userArn\",\r\n    \"request-id\" : \"$context.requestId\",\r\n    \"resource-id\" : \"$context.resourceId\",\r\n    \"resource-path\" : \"$context.resourcePath\"\r\n    }\r\n}"
  }
}

resource "aws_api_gateway_method_response" "rest_api_options_method_response_200" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.rest_api_resource.id
  http_method = aws_api_gateway_method.rest_api_options_method.http_method

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = false,
    "method.response.header.Access-Control-Allow-Methods" = false,
    "method.response.header.Access-Control-Allow-Origin"  = false
  }

  status_code = "200"
}

resource "aws_api_gateway_method_response" "rest_api_post_method_response_200" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.rest_api_resource.id
  http_method = aws_api_gateway_method.rest_api_post_method.http_method

  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}

resource "aws_api_gateway_method_response" "rest_api_post_method_response_400" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.rest_api_resource.id
  http_method = aws_api_gateway_method.rest_api_post_method.http_method
  status_code = "400"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
  }
}

resource "aws_api_gateway_integration_response" "rest_api_options_method_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.rest_api_resource.id
  http_method = aws_api_gateway_integration.rest_api_options_method_integration.http_method

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  status_code = "200"

  depends_on = [
    aws_api_gateway_integration.rest_api_options_method_integration
  ]
}

resource "aws_api_gateway_integration_response" "rest_api_post_method_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.rest_api_resource.id
  http_method = aws_api_gateway_integration.rest_api_post_method_integration.http_method

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = ""
  }
  
  status_code = "200"

  depends_on = [
    aws_api_gateway_integration.rest_api_post_method_integration
  ]
}

resource "aws_api_gateway_integration_response" "rest_api_post_method_integration_response_400" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.rest_api_resource.id
  http_method = aws_api_gateway_integration.rest_api_post_method_integration.http_method

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = "#set($inputRoot = $input.path('$'))\n$inputRoot.errorMessage"
  }

  selection_pattern = ".*\"statusCode\":400.*"
  status_code       = "400"
}

// Creating a lambda resource based policy to allow API gateway to invoke the lambda function:
resource "aws_lambda_permission" "api_gateway_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.api_gateway_region}:${var.api_gateway_account_id}:${aws_api_gateway_rest_api.rest_api.id}/*/*${aws_api_gateway_resource.rest_api_resource.path}"
}

resource "aws_api_gateway_deployment" "rest_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.rest_api_resource.id,
      aws_api_gateway_method.rest_api_options_method.id,
      aws_api_gateway_integration.rest_api_options_method_integration.id,
      aws_api_gateway_method.rest_api_post_method.id,
      aws_api_gateway_integration.rest_api_post_method_integration.id
    ]))
  }
  lifecycle { create_before_destroy = true }
}

resource "aws_api_gateway_stage" "rest_api_stage" {
  deployment_id = aws_api_gateway_deployment.rest_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = var.rest_api_stage_name
}
