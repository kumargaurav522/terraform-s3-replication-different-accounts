# ------------------------------------------------------------------------------
# S3 bucket to act as the replication target.
# ------------------------------------------------------------------------------

resource "aws_s3_bucket" "destination" {
  provider = aws.dest
  bucket = "test-tf1-des"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }
}

# ------------------------------------------------------------------------------
# The destination bucket needs a policy that allows the source account to
# replicate into it.
# ------------------------------------------------------------------------------
resource "aws_s3_bucket_policy" "destination" {
  provider = aws.dest
  bucket   = aws_s3_bucket.destination.id

  policy = <<POLICY
{
   "Version":"2012-10-17",
   "Id":"",
   "Statement":[
      {
         "Sid":"Set permissions for objects",
         "Effect":"Allow",
         "Principal":{
            "AWS":"arn:aws:iam::${var.source_account}:role/${aws_iam_role.replication.name}"
         },
         "Action":["s3:ReplicateObject", "s3:ReplicateDelete"],
         "Resource":"${aws_s3_bucket.destination.arn}/*"
      },
      {
         "Sid":"Set permissions on bucket",
         "Effect":"Allow",
         "Principal":{
            "AWS":"arn:aws:iam::${var.source_account}:role/${aws_iam_role.replication.name}"
         },
         "Action":["s3:GetBucketVersioning", "s3:PutBucketVersioning"],
         "Resource":"${aws_s3_bucket.destination.arn}"
      }
   ]
}
POLICY

}

