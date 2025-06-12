variable "project_name" {
  default = "netvizion"
}

resource "aws_kinesis_stream" "netvizion_stream" {
  name             = "${var.project_name}-stream"
  shard_count      = 1
  retention_period = 24
}

resource "aws_timestreamwrite_database" "netvizion_db" {
  database_name = "${var.project_name}_db"
}

resource "aws_timestreamwrite_table" "netvizion_table" {
  database_name = aws_timestreamwrite_database.netvizion_db.database_name
  table_name    = "${var.project_name}_table"

  retention_properties {
    memory_store_retention_period_in_hours = 24
    magnetic_store_retention_period_in_days = 7
  }
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.project_name}_lambda_exec"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "processor" {
  filename         = "${path.module}/../processor/lambda.zip"
  function_name    = "${var.project_name}_processor"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("${path.module}/../processor/lambda.zip")
  runtime          = "python3.11"
  timeout          = 30
}

resource "aws_lambda_event_source_mapping" "kinesis_trigger" {
  event_source_arn = aws_kinesis_stream.netvizion_stream.arn
  function_name    = aws_lambda_function.processor.arn
  starting_position = "LATEST"
  batch_size        = 100
}

# Attach Kinesis read permissions to Lambda role
resource "aws_iam_role_policy_attachment" "lambda_kinesis" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisReadOnlyAccess"
}
