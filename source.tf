# ------------------------------------------------------------------------------
# IAM role that S3 can use to read our bucket for replication
# ------------------------------------------------------------------------------
resource "aws_iam_role" "replication" {
  provider    = aws.source
  name_prefix = "replication"
  description = "Allow S3 to assume the role for replication"

  assume_role_policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[
       {
          "Effect":"Allow",
          "Principal":{
             "Service":"s3.amazonaws.com"
          },
          "Action":"sts:AssumeRole"
       }
    ]
 }
POLICY

}

resource "aws_iam_policy" "replication" {
  provider    = aws.source
  name_prefix = "replication"
  description = "Allows reading for replication."
  policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[
       {
          "Effect":"Allow",
          "Action":[
             "s3:GetObjectVersionForReplication",
             "s3:GetObjectVersionAcl",
             "s3:GetObjectVersionTagging"
          ],
          "Resource":[
             "${aws_s3_bucket.source.arn}/*"
          ]
       },
       {
          "Effect":"Allow",
          "Action":[
             "s3:ListBucket",
             "s3:GetReplicationConfiguration"
          ],
          "Resource":[
             "${aws_s3_bucket.source.arn}"
          ]
       },
       {
          "Effect":"Allow",
          "Action":[
             "s3:ReplicateObject",
             "s3:ReplicateDelete",
             "s3:ReplicateTags"
          ],
          "Resource":"${aws_s3_bucket.destination.arn}/*"
       }
    ]
 }
POLICY
}

resource "aws_iam_policy_attachment" "replication" {
  provider   = aws.source
  name       = "replication"
  roles      = [aws_iam_role.replication.name]
  policy_arn = aws_iam_policy.replication.arn
}


# ------------------------------------------------------------------------------
# S3 bucket to act as the replication source, i.e. the primary copy of the data
# ------------------------------------------------------------------------------

resource "aws_s3_bucket" "log_bucket_source" {
  bucket = "my-tf-log-bucket-hgb"
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket" "source" {
  provider = aws.source
  bucket = "test-tf1-sou"
  acl    = "private"

  versioning {
    enabled = true
  }
  logging {
    target_bucket = aws_s3_bucket.log_bucket_source.id
    target_prefix = "log/"
  }
  lifecycle {
    prevent_destroy = false
  }

 

  replication_configuration {
    role = aws_iam_role.replication.arn

    rules {
      
      status = "Enabled"
      priority = "1"

      destination {
        bucket      = aws_s3_bucket.destination.arn
      }
    }
  }
}

# ------------------------------------------------------------------------------
# finally put something in the bucket to replicate
# ------------------------------------------------------------------------------
resource "aws_s3_bucket_object" "sample" {
  provider     = aws.source
  key          = "samplefile.txt"
  bucket       = aws_s3_bucket.source.id
  source       = "${path.module}/samplefile.txt"
  content_type = "text/plain"
  etag         = filemd5("${path.module}/samplefile.txt")
}

