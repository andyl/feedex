# >>>>>> LocalTest
# Build: docker build -t phx-ragged .
# Run:   docker run -p 8444:4000 phx-ragged
#
# >>>>>> DockerHub
# Build: docker build -t <yourname>/ragged .
# Login: docker login -u <yourname>
# Push:  docker push <yourname>/ragged
# Run:   docker run -p 8444:4000 <yourname>/ragged

FROM elixir:1.9

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

WORKDIR /app
ENV MIX_ENV=prod
COPY _build/prod/rel/ragged /app/
EXPOSE 4000

CMD /app/bin/ragged foreground
