FROM python:3.6.10-alpine3.11

ENV GEO_KEY ''
ENV USER ''
ENV PASSWORD ''

RUN apk update && apk add --no-cache gcc \
    libc-dev \
    libffi-dev \
    python3-dev \
    make

COPY requirements.txt /tmp/requirements.txt 
RUN pip3 install -r /tmp/requirements.txt 
RUN pip3 install "connexion[swagger-ui]"


COPY app.py /
COPY swagger.yaml /
COPY schema.json /

RUN chmod 777 /app.py
RUN chmod 777 /swagger.yaml

EXPOSE 8080

WORKDIR /

ENTRYPOINT [ "python3", "/app.py" ]