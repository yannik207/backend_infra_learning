#! /bin/sh
gcloud builds submit --project=$GOOGLE_PROJECT_ID --config=cloudbuild.yaml \
    --gcs-source-staging-dir="${CLOUD_BUILD_BUCKET}/source" --timeout=20m \
    --substitutions=_REPOSITORY="${ARTIFACT_REPO}",_IMAGE="${IMAGE_NAME}",_CI_COMMIT_TAG=${CI_COMMIT_TAG} .
