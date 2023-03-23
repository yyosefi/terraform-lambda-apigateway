## Terraform module for Lambda and API Gateway

The module creates an AWS Lambda with API Gateway
The lambda function listes for HTTP POST requests and sends back a response from a Node.js application


## Testing

``` curl -X POST rest_api_url ```

rest_api_url - The URL value of the module output


## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_api_gateway"></a> [api\_gateway](#module\_api\_gateway) | ./modules/api_gateway | n/a |
| <a name="module_lambda_function"></a> [lambda\_function](#module\_lambda\_function) | ./modules/lambda_function | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | The account ID in which to create/manage resources | `string` | n/a | yes |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | The name of the Lambda function | `string` | n/a | yes |
| <a name="input_rest_api_stage_name"></a> [rest\_api\_stage\_name](#input\_rest\_api\_stage\_name) | The name of the API Gateway stage | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region in which to create/manage resources | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rest_api_url"></a> [rest\_api\_url](#output\_rest\_api\_url) | n/a |
