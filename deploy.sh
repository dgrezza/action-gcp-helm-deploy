#!/usr/bin/env bash

# Login to Kubernetes Cluster.
echo "$SERVICEACCOUNT_KEY" > serviceaccount.json
gcloud auth activate-service-account ${SERVICEACCOUNT_NAME} --key-file=serviceaccount.json
gcloud container clusters get-credentials ${GKE_CLUSTER_NAME} --region ${GCP_REGION} --project ${GCP_PROJECT}
gcloud config set project ${GCP_PROJECT}

# Helm Deployment
if [ ! -n "$DEPLOY_NAMESPACE" ]; then
    case ${GITHUB_REF_NAME} in
      test)
        DEPLOY_NAMESPACE=test
      ;;
      main)
        DEPLOY_NAMESPACE=production
      ;; 
      *)
        DEPLOY_NAMESPACE=test
      ;; 
    esac
    echo ${DEPLOY_NAMESPACE}
fi

if [ ! -n "$DEPLOY_CHART_PATH" ]; then
   DEPLOY_CHART_PATH="helm/${APP_NAME}"
fi

if [ ! -n "$DEPLOY_CONFIG_FILES" ]; then
   DEPLOY_CONFIG_FILES="${DEPLOY_NAMESPACE}.yaml"
fi

if [ ! -n "$DEPLOY_NAME" ]; then
   DEPLOY_NAME="${DEPLOY_NAMESPACE}-${APP_NAME}"
fi

helm upgrade --install \
	--set-string image.tag=${DEPLOY_IMAGE_TAG} \
	--namespace ${DEPLOY_NAMESPACE} \
	-f ${DEPLOY_CHART_PATH}/${DEPLOY_CONFIG_FILES} ${DEPLOY_NAME} ${DEPLOY_CHART_PATH}
