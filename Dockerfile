ARG FUNCTION_DIR="/src"

FROM ubuntu as build-image

RUN apt-get update && \
  apt-get install -y \
  g++ \
  make \
  cmake \
  unzip \
  libcurl4-openssl-dev

RUN apt install tesseract-ocr -y
RUN apt install libtesseract-dev -y
RUN apt-get install python3 -y 
RUN apt-get install python3-pip -y

ARG FUNCTION_DIR

COPY ${FUNCTION_DIR} ${FUNCTION_DIR} 

RUN pip install \
    --target ${FUNCTION_DIR} \
        awslambdaric

WORKDIR ${FUNCTION_DIR}

ENTRYPOINT [ "python3", "-m", "awslambdaric" ]
CMD ["app.handler"]