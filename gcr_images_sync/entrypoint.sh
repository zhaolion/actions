#!/bin/bash
# docker login
echo "${INPUT_PASSWORD}" | docker login -u ${INPUT_USERNAME} --password-stdin ${INPUT_REGISTRY}

# download image file to local file
curl -o images ${INPUT_IMAGES}

# read it
images=`cat images`

while IFS='/' read key value; do
    # gcr image
    image=${key}/${value}
    # dockerhub image
    new_image=${INPUT_REPOSITORY}/${value}
    if [ -n "${INPUT_REGISTRY}" ]; then
        new_image=${INPUT_REGISTRY}/${new_image}
    fi

    docker pull ${image}
    docker tag ${image} ${new_image}
    docker push ${new_image}
done <<< ${images}
