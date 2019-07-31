import RaggedData.Factory

if Mix.env() == :dev do
  insert_list(5, :feed_log)
end
