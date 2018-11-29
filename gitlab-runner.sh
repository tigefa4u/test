docker run --privileged -d --name gitlab-runner --restart always \
  -v /srv/gitlab-runner/config:/etc/gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e TZ=Asia/Jakarta \
  gitlab/gitlab-runner:latest

docker exec -it gitlab-runner gitlab-runner register \
  --non-interactive \
  --executor "docker" \
  --docker-image tigefa/bionic:latest \
  --url "https://gitlab.com/" \
  --registration-token "xBjWbsmr2zgzCZ8ptuYy" \
  --description "docker-circleci-tigefa4u" \
  --tag-list "docker,aws,gce,circleci" \
  --run-untagged \
  --locked="false"

docker exec -it gitlab-runner sed -i -e 's/concurrent = 1/concurrent = 100/g' /etc/gitlab-runner/config.toml

docker exec -it gitlab-runner sed -i -e 's/privileged = false/privileged = true/g' /etc/gitlab-runner/config.toml

docker exec -it gitlab-runner sed -i -e 's/disable_cache = false/disable_cache = true/g' /etc/gitlab-runner/config.toml
