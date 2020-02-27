FROM elixir

COPY . /opt/source-code
RUN cd /opts/source-code
RUN mix deps.get

