FROM golang:1.9-alpine	

EXPOSE 8081

WORKDIR /go/src/app

RUN apk --no-cache add curl git 

RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

COPY . .
RUN dep ensure

RUN go build -o auth-api

CMD /go/src/app/auth-api

FROM snyk/snyk:python AS scan
ARG SNYK_TOKEN
ENV SNYK_TOKEN=${SNYK_TOKEN}

COPY run-snyk-test.sh .

RUN ./run-snyk-test.sh

FROM scratch AS scan-result
COPY --from=scan /snyk/output .
