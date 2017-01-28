FROM python:3.5

RUN \
  mkdir -pv /var/eg && \
  cd /var/eg

WORKDIR /var/eg

COPY requirements.txt /var/eg

RUN \
  pip install -r requirements.txt && \
  pip install -U nose && \
  rm -rf /var/tmp/* /tmp/* /var/lib/apt/lists/*

COPY . /var/eg
