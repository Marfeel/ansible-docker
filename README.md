# Ansible image to be used with our Jenkins

> [!IMPORTANT]  
> Moved to [Marfeel/DockerImageAnsible](https://github.com/Marfeel/DockerImageAnsible)

This is an auto built docker image Dockerfile with the resulting image available [here from the Docker Hub](https://cloud.docker.com/u/marfeel/repository/docker/marfeel/ansible-docker)

Builds are triggered from tags with numbered versions (regex `^[0-9.]+$`) released as `release-[version]`

Branches should be built, if not master, as `br-[ref]`. Master commits are always built as `latest`.
