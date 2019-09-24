# >>>>>> LocalTest
# Build: docker build -t phx-feedex .
# Run:   docker run -p 8444:5060 phx-feedex
#
# >>>>>> DockerHub
# Build: docker build -t <yourname>/feedex .
# Login: docker login -u <yourname>
# Push:  docker push <yourname>/feedex
# Run:   docker run -p 8444:5060 <yourname>/feedex

FROM elixir:1.9

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

WORKDIR /app
ENV MIX_ENV=prod
COPY _build/prod/rel/feedex /app/
EXPOSE 5060

CMD /app/bin/feedex foreground
