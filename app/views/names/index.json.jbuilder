json.array!(@names) do |name|
  json.extract! name, :title, :subtitle
  json.url name_url(name, format: :json)
end