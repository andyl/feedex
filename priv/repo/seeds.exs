# Add application data
# > mix run priv/repo/seeds.exs

import RaggedData.Factory

if Mix.env() == :dev do
  insert_list(5, :feed_log)
  insert_list(3, :post)
  insert_list(2, :feed)
end
