// Specify the provider (GCP, AWS, Azure)

provider "aws" {
  region	= "${var.region}"
//  profile	= "${var.AWS_PROFILE}"
}
