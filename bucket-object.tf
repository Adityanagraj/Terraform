###########################################################################################################################
Here we will create bucket In google and upload a image inside the bucket
############################################################################################################################


provider "google" {
  project     = <project_ID>
  region      = <region>
  credentials = <example.json>
}
resource "google_storage_bucket" "bucket-with-tf" {
  name          = "bucket-with-tf"
  location      = "US"
}
resource "google_storage_bucket_object" "image" {
  name   = "image"
  source = "<path_of_file>"
  bucket =  google_storage_bucket.bucket-with-tf.name
}
