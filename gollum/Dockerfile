FROM ruby:2.6.6
RUN apt-get -y update && apt-get -y install libicu-dev cmake && rm -rf /var/lib/apt/lists/*
RUN gem install github-linguist
RUN gem install gollum
WORKDIR /wiki
ENTRYPOINT ["gollum", "--port", "80", "--css", "--js", "--allow-uploads", "page", "--mathjax", "--user-icons", "gravatar", "--emoji", "--host", "0.0.0.0", "--no-edit"]
EXPOSE 80
