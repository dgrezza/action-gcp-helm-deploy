FROM gcr.io/google.com/cloudsdktool/google-cloud-cli:alpine

ARG KUBECTL_VERSION="1.21.2"

RUN apk add py-pip curl wget ca-certificates git bash jq gcc alpine-sdk
RUN curl -L -o /usr/bin/kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
RUN chmod +x /usr/bin/kubectl

RUN wget https://get.helm.sh/helm-v3.8.0-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm
RUN chmod +x /usr/local/bin/helm

RUN gcloud components install gke-gcloud-auth-plugin

COPY deploy.sh /deploy.sh
RUN chmod +x /deploy.sh

ENTRYPOINT ["/deploy.sh"]:
