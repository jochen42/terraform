####
# builder-stage
FROM golang:1.12-alpine as builder
ARG TERRAFORM_VERSION
ENV TERRAFORM_VERSION ${TERRAFORM_VERSION:-}

RUN go version
RUN apk add --no-cache git curl unzip build-base
RUN mkdir -p /root/.terraform.d/plugins/linux_amd64

# aws plugin
RUN go get -v github.com/terraform-providers/terraform-provider-aws
RUN cp $GOPATH/bin/terraform-provider-aws /root/.terraform.d/plugins/$(uname | tr '[:upper:]' '[:lower:]')_amd64/terraform-provider-aws_v$(date +%Y.%m.%d)

# vault plugin
RUN go get -v github.com/terraform-providers/terraform-provider-vault
RUN cp $GOPATH/bin/terraform-provider-vault /root/.terraform.d/plugins/$(uname | tr '[:upper:]' '[:lower:]')_amd64/terraform-provider-vault_v$(date +%Y.%m.%d)

# pingdom plugin
RUN go get -v github.com/russellcardullo/terraform-provider-pingdom
RUN cp $GOPATH/bin/terraform-provider-pingdom /root/.terraform.d/plugins/$(uname | tr '[:upper:]' '[:lower:]')_amd64/terraform-provider-pingdom_v$(date +%Y.%m.%d)

# keycloak plugin
RUN go get -v github.com/mrparkers/terraform-provider-keycloak
RUN cp $GOPATH/bin/terraform-provider-keycloak /root/.terraform.d/plugins/$(uname | tr '[:upper:]' '[:lower:]')_amd64/terraform-provider-keycloak_v$(date +%Y.%m.%d)

# kong plugin
RUN go get -v github.com/kevholditch/terraform-provider-kong
RUN cp $GOPATH/bin/terraform-provider-kong /root/.terraform.d/plugins/$(uname | tr '[:upper:]' '[:lower:]')_amd64/terraform-provider-kong_v$(date +%Y.%m.%d)

# Dead Man's Snitch
RUN go get -v github.com/plukevdh/terraform-provider-dmsnitch
RUN cp $GOPATH/bin/terraform-provider-dmsnitch /root/.terraform.d/plugins/$(uname | tr '[:upper:]' '[:lower:]')_amd64/terraform-provider-dmsnitch_v$(date +%Y.%m.%d)

# Kibana
RUN go get -v github.com/ewilde/terraform-provider-kibana
RUN cp $GOPATH/bin/terraform-provider-kibana /root/.terraform.d/plugins/$(uname | tr '[:upper:]' '[:lower:]')_amd64/terraform-provider-kibana_v$(date +%Y.%m.%d)

# pass/gopass
RUN go get -v github.com/camptocamp/terraform-provider-pass
RUN cp $GOPATH/bin/terraform-provider-pass /root/.terraform.d/plugins/$(uname | tr '[:upper:]' '[:lower:]')_amd64/terraform-provider-sops_v$(date +%Y.%m.%d)

# mozilla sops
RUN go get -v github.com/carlpett/terraform-provider-sops
RUN cp $GOPATH/bin/terraform-provider-sops /root/.terraform.d/plugins/$(uname | tr '[:upper:]' '[:lower:]')_amd64/terraform-provider-pass_v$(date +%Y.%m.%d)

# terraform bin
RUN curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN unzip /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin

###
# final image stage
FROM golang:1.12-alpine
ARG TERRAFORM_VERSION
ENV TERRAFORM_VERSION ${TERRAFORM_VERSION:-}

LABEL maintainer="Jochen Weber <jochen.weber80@gmail.com>"
LABEL terraform_version=$TERRAFORM_VERSION

RUN mkdir -p /app
COPY --from=builder /root/.terraform.d /root/.terraform.d
COPY --from=builder /bin/terraform /bin/terraform
WORKDIR /app