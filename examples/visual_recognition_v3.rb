# frozen_string_literal: true

require("ibm_watson/visual_recognition_v3")
require("json")

test_url = "https://www.ibm.com/ibm/ginni/images/ginni_bio_780x981_v4_03162016.jpg"

# If using IAM
visual_recognition = IBMWatson::VisualRecognitionV3.new(
  version: "2018-03-19",
  iam_apikey: "IAM API KEY"
)

# If you have username & password in your credentials use:
# visual_recognition = IBMWatson::VisualRecognitionV3.new(
#   version: "2018-03-19",
#   username: "YOUR SERVICE USERNAME",
#   password: "YOUR SERVICE PASSWORD"
# )

# cars = File.open(Dir.getwd + "/resources/cars.zip")
# trucks = File.open(Dir.getwd + "/resources/trucks.zip")
# puts JSON.pretty_generate(visual_recognition.create_classifier(
#   name: "Cars vs Trucks",
#   positive_examples: { cars: cars },
#   negative_examples: trucks
# ).result)

File.open(Dir.getwd + "/resources/cars.zip") do |images_file|
  car_results = visual_recognition.classify(
    images_file: images_file,
    threshold: 0.1,
    classifier_ids: ["defaults"]
  ).result
  puts JSON.pretty_generate(car_results)
end

# puts JSON.pretty_generate(visual_recognition.get_classifier(classifier_id: "YOUR CLASSIFIER ID").result)

# File.open(Dir.getwd + "/resources/car.jpg") do |image_file|
#   puts JSON.pretty_generate(visual_recognition.update_classifier(
#     classifier_id: "CarsvsTrucks_1479118188",
#     positive_examples: { cars: image_file }
#   ).result)
# end

url_result = visual_recognition.classify(url: test_url).result
puts JSON.pretty_generate(url_result)

faces_result = visual_recognition.detect_faces(url: test_url).result
puts JSON.pretty_generate(faces_result)

# puts JSON.pretty_generate(visual_recognition.delete_classifier(classifier_id: "YOUR CLASSIFIER ID"))

puts JSON.pretty_generate(visual_recognition.list_classifiers.result)

File.open(Dir.getwd + "/resources/face.jpg") do |image_file|
  face_result = visual_recognition.detect_faces(images_file: image_file).result
  puts JSON.pretty_generate(face_result)
end
