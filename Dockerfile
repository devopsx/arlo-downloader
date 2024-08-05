FROM python:3.9-slim

# TODO: drop after switching to a proper release version of pyaarlo
# Needed for installing better-error branch
RUN apt-get update \
    && apt-get install -y git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists

ENV UID=999
ENV GID=999

# ./aarlo is session cache dir
RUN mkdir -p /arlo-downloader/aarlo /records \
    && groupadd -g $GID arlo-downloader \
    && useradd -u $UID -g arlo-downloader arlo-downloader

# Switch to arlo-downloader directory
WORKDIR /arlo-downloader

COPY requirements.txt ./

# Install required packages
RUN pip install -r requirements.txt

COPY arlo-downloader.py config.py entrypoint.sh ./

ENV ARLO_USERNAME=_invalid
ENV ARLO_PASSWORD=_invalid
ENV TFA_TYPE=PUSH
ENV TFA_SOURCE=push
ENV TFA_RETRIES=10
ENV TFA_DELAY=5
ENV TFA_HOST=_invalid
ENV TFA_USERNAME=_invalid
ENV TFA_PASSWORD=_invalid
ENV SAVE_MEDIA_TO='/records/${Y}/${m}/${F}T${t}_${N}_${SN}'
ENV DEBUG=0
ENV SENTRY_DSN=_invalid

# Setting our entrypoint
ENTRYPOINT ["/arlo-downloader/entrypoint.sh"]
