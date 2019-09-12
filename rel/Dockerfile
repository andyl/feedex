# >>>>>> LocalTest
# Build: docker build -t phx-ragged .
# Run:   docker run -p 8444:5060 phx-ragged
#
# >>>>>> DockerHub
# Build: docker build -t <yourname>/ragged .
# Login: docker login -u <yourname>
# Push:  docker push <yourname>/ragged
# Run:   docker run -p 8444:5060 <yourname>/ragged

FROM elixir:1.9

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

WORKDIR /app
ENV MIX_ENV=prod
COPY _build/prod/rel/ragged /app/
EXPOSE 5060

CMD /app/bin/ragged foreground
