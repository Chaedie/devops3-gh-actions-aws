FROM golang:1.17-buster AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN go build -o /3-gh-actions-aws

FROM gcr.io/distroless/base-debian10

WORKDIR / 

COPY --from=build /3-gh-actions-aws /3-gh-actions-aws

USER nonroot:nonroot

ENTRYPOINT ["/3-gh-actions-aws"]