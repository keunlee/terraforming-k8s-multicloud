gcloud auth login
export PROJECT_ID=YOUR_PROJECT_ID
gcloud config set project ${PROJECT_ID}
export PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="value(projectNumber)")

gcloud services enable \
    container.googleapis.com \
    compute.googleapis.com \
    stackdriver.googleapis.com \
    meshca.googleapis.com \
    meshtelemetry.googleapis.com \
    meshconfig.googleapis.com \
    iamcredentials.googleapis.com \
    anthos.googleapis.com

export CLUSTER_NAME=YOUR_CLUSTER_NAME
export CLUSTER_ZONE=YOUR_CLUSTER_ZONE
export IDNS=${PROJECT_ID}.svc.id.goog
export MESH_ID="proj-${PROJECT_NUMBER}"
gcloud config set compute/zone ${CLUSTER_ZONE}
gcloud container clusters describe ${CLUSTER_NAME}
export EXISTING_LABELS="env=dev,release=stable"

gcloud beta container clusters update ${CLUSTER_NAME} --identity-namespace=${IDNS}
gcloud beta container clusters update ${CLUSTER_NAME} --enable-stackdriver-kubernetes
gcloud beta container clusters update ${CLUSTER_NAME} --update-labels mesh_id=${MESH_ID}

curl --request POST \
  --header "Authorization: Bearer $(gcloud auth print-access-token)" \
  --data '' \
  https://meshconfig.googleapis.com/v1alpha1/projects/${PROJECT_ID}:initialize

gcloud container clusters get-credentials ${CLUSTER_NAME}

kubectl create clusterrolebinding cluster-admin-binding \
  --clusterrole=cluster-admin \
  --user="$(gcloud config get-value core/account)"

curl -LO https://storage.googleapis.com/gke-release/asm/istio-1.4.7-asm.0-linux.tar.gz

tar xzf istio-1.4.7-asm.0-linux.tar.gz

cd istio-1.4.7-asm.0

export PATH=$PWD/bin:$PATH


