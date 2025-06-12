output "kinesis_stream_name" {
  value = aws_kinesis_stream.netvizion_stream.name
}

output "timestream_table_name" {
  value = aws_timestreamwrite_table.netvizion_table.table_name
}
