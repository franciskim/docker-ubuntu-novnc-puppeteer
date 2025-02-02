# Has to be authorized using:
# Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
$REPO="franciskim/"
$IMAGE="ubuntu-novnc-puppeteer"
$TAG="22.04"
$RESOL="1700x950"
docker run --rm -d -p 6080:80 -v "$(PWD):/workspace:rw" -e "RESOLUTION=${RESOL}" --name "${IMAGE}-run" "${REPO}${IMAGE}:${TAG}"
Start-Sleep -s 5
Start http://localhost:6080