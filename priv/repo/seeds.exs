# Add application data
# > mix run priv/repo/seeds.exs

require Logger

Logger.info("------------------------------------------------------")
Logger.info("----- LOADING_SEED_DATA ")
Logger.info("------------------------------------------------------")

Feedex.Seeds.load_if_empty()
