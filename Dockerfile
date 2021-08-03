# Main Dockerfile from acquasecurity (This build fails - was unusable) -- https://hub.docker.com/r/aquasec/trivy/dockerfile
# Install Go on Alpine -- Ref: https://stackoverflow.com/questions/52056387/how-to-install-go-in-alpine-linux
FROM alpine:3.14
RUN apk add --update --no-cache vim git make musl-dev go curl

# Configure Go
RUN export GOPATH=/root/go
RUN export PATH=${GOPATH}/bin:/usr/local/go/bin:$PATH
RUN export GOBIN=$GOROOT/bin
RUN mkdir -p ${GOPATH}/src ${GOPATH}/bin
RUN export GO111MODULE=on

# Echo Go version - confirm install
RUN go version

# Install Trivy
WORKDIR /acquasecurity
RUN git clone https://github.com/aquasecurity/trivy.git
WORKDIR /acquasecurity/trivy
ENV NODE_ENV=production
RUN go mod verify
RUN mv cmd/trivy/main.go cmd/trivy/trivy.go
RUN go install cmd/trivy/trivy.go

# Checking go environment variables - GOPATH determines where package was installed
RUN go env
ENTRYPOINT ["/root/go/bin/trivy"]
