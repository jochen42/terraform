FROM golang:1.12-alpine as builder
ENV TERRAFORM_VERSION="0.12.3"

RUN apk add --no-cache git curl unzip
RUN mkdir -p /root/.terraform.d/plugins/linux_amd64

# pingdom plugin
RUN go get -v github.com/russellcardullo/terraform-provider-pingdom
RUN ln -s $GOPATH/bin/terraform-provider-pingdom /root/.terraform.d/plugins/$(uname | tr '[:upper:]' '[:lower:]')_amd64/terraform-provider-pingdom_v$(date +%Y.%m.%d)

# terraform plugin
RUN go get -v github.com/mrparkers/terraform-provider-keycloak
RUN ln -s $GOPATH/bin/terraform-provider-keycloak /root/.terraform.d/plugins/$(uname | tr '[:upper:]' '[:lower:]')_amd64/terraform-provider-keycloak_v$(date +%Y.%m.%d)

# terraform bin
RUN curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN unzip /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin

FROM golang:1.12-alpine
LABEL maintainer="Jochen Weber <jochen.weber@aoe.com>"
RUN mkdir -p /app
COPY --from=builder /root/.terraform.d /root/.terraform.d
COPY --from=builder /go /go
COPY --from=builder /bin/terraform /bin/terraform
WORKDIR /app