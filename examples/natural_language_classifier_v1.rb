require("watson_apis/natural_language_classifier_v1")

natural_language_classifier = WatsonAPIs::NaturalLanguageClassifierV1.new(
  username: "YOUR SERVICE USERNAME",
  password: "YOUR SERVICE PASSWORD"
)

classifiers = natural_language_classifier.list_classifiers.body
p classifiers

# create a classifier
training_data = File.open(Dir.getwd + "/resources/weather_data_train.csv")
metadata = {
  "name" => "my-classifier",
  "language" => "en"
}
classifier = natural_language_classifier.create_classifier(
  metadata: metadata,
  training_data: training_data
).body
classifier_id = classifier["classifier_id"]
p classifier

status = natural_language_classifier.get_classifier(
  classifier_id: classifier_id
).body
p status

if status["status"] == "Available"
  classes = natural_language_classifier.classify(
    classifier_id: classifier_id,
    text: "How hot will it be tomorrow?"
  ).body
  p classes
end

if status["status"] == "Available"
  collection = [{ "text" => "How hot will it be today?" }, { "text" => "Is it hot outside?" }]
  classes = natural_language_classifier.classify_collection(
    classifier_id: classifier_id,
    collection: collection
  ).body
  p classes
end

delete = natural_language_classifier.delete_classifier(classifier_id: classifier_id).body
p delete