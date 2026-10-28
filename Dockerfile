ARG RUBY_VERSION=3.3
FROM ruby:${RUBY_VERSION}-slim

RUN apt-get update \
  && apt-get install -y --no-install-recommends build-essential git \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile svg_inline_file_extractor.gemspec ./
COPY lib/svg_inline_file_extractor/version.rb lib/svg_inline_file_extractor/version.rb
RUN bundle install --jobs 4

COPY . .

CMD ["bundle", "exec", "rake"]
