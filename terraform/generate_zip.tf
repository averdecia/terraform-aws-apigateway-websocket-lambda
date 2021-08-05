data "archive_file" "zip_code" {
  output_path = "dist/lambda.zip"
  source_dir = "../app"
  type = "zip"
  output_file_mode = "0666"
}